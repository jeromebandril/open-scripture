import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/infrastructure/event_bus/search_result_bus.dart';
import '../../../../../core/infrastructure/event_bus/selected_verse_bus.dart';
import '../../../../../shared/domain/entities/bible_id.dart';
import '../../../../../shared/domain/entities/bible_ref.dart';
import '../../../../../shared/domain/repositories/bible_pane_repository_factory.dart';
import '../../../../../shared/enums/bible_repository_type.dart';
import '../../domain/display_mode.dart';
import '../../domain/repositories/bible_pane_repository.dart';
import '../models/parallel_bible_config.dart';

part 'bible_pane_event.dart';
part 'bible_pane_state.dart';

class BiblePaneBloc extends Bloc<BiblePaneEvent, BiblePaneState> {
  /// How long an async operation must run before we bother showing a
  /// loading state. Prevents the UI from flashing on fast responses.
  static const _loadingIndicatorThreshold = Duration(milliseconds: 250);

  BiblePaneBloc({
    required int paneId,
    required BibleRepositoryFactory repositoryFactory,
    SelectedVerseBus? notifier,
    SearchResultBus? navBus,
  })  : _repositoryFactory = repositoryFactory,
        _navBus = navBus,
        _overlayNotifier = notifier,
        super(BiblePaneState(
            paneId: paneId, status: BiblePaneStatus.selectBibles)) {
    on<BiblePaneOpen>(_onBiblePaneOpen);
    on<BiblePaneDisplayChapter>(_onBiblePaneDisplayChapter);
    on<BiblePaneJustChangeRef>(_onChangeRef);
    on<BiblePaneChooseBibles>(_onOpenBibleSelection);
    // on<BiblePaneDisplayVerses>(_onDisplayVerses);
    on<BiblePaneSetDisplayMode>(_onChangeDisplayMode);
  }

  final SearchResultBus? _navBus;
  final SelectedVerseBus? _overlayNotifier;
  final BibleRepositoryFactory _repositoryFactory;
  // final _resolver = sl<BibleRefResolver>();

  Future<BiblePaneRepository> get _repo async =>
      await _repositoryFactory.get(state.repoType);

  // Add a bible translation to the content
  Future<void> _onBiblePaneOpen(
    BiblePaneOpen event,
    Emitter<BiblePaneState> emit,
  ) async {
    emit(state.copyWith(status: () => BiblePaneStatus.loading));
    final repoType = event.bibleIds.first.repoType;
    final repo = await _repositoryFactory.get(repoType);

    final newMap = ParallelBibleMap.from(state.content.asMap);

    for (final id in event.bibleIds) {
      // check if bible actually exists
      final result = await repo.getBibleMetadata(bibleId: id);

      result.fold(
        (f) {
          emit(state.copyWith(
            status: () => BiblePaneStatus.error,
            content: () => ParallelBibleConfig.empty,
            errorMessage: () => f.message,
          ));
          return;
        },
        (bm) {
          // Add only new translations
          if (newMap[id] != null) return;
          newMap[id] = BibleData(meta: bm);
        },
      );
    }

    // Remove translations that are not selected
    for (final id in state.openedBiblesIds) {
      if (!event.bibleIds.contains(id)) newMap.remove(id);
    }

    emit(state.copyWith(
      status: () => BiblePaneStatus.ready,
      content: () => ParallelBibleConfig.from(newMap),
      parallelOrder: () => event.bibleIds,
      isMixed: () => false,
      repoType: () => repoType,
    ));

    // fetch and update content if reference is not null
    if (state.reference == null) return;
    add(BiblePaneDisplayChapter(ref: state.reference!));
  }

  /// Display passed bible refs directly
  // Future<void> _onDisplayVerses(
  //   BiblePaneDisplayVerses event,
  //   Emitter<BiblePaneState> emit,
  // ) async {
  //   if (state.openedBiblesIds.isEmpty) return;

  //   final newMap = Map<BibleId, ParallelBibleData>.from(state.content.asMap);

  //   for (var id in state.openedBiblesIds) {
  //     final result = await repo.getVersesWithSpans(
  //       bibleId: id,
  //       refs: event.refs,
  //     );

  //     result.fold(
  //       (_) => newMap[id] = newMap[id]!.copyWith(
  //         verses: () => null,
  //       ),
  //       (s) => newMap[id] = newMap[id]!.copyWith(
  //         verses: () => Verse.groupMixedSegmentsIntoVerses(s),
  //       ),
  //     );
  //   }

  //   emit(state.copyWith(
  //     status: () => BiblePaneStatus.ready,
  //     content: () => ParallelBibleConfig.from(newMap),
  //     isMixed: () => true,
  //   ));
  // }

  /// Display the verses of the whole selected chapter
  Future<void> _onBiblePaneDisplayChapter(
    BiblePaneDisplayChapter event,
    Emitter<BiblePaneState> emit,
  ) async {
    if (state.openedBiblesIds.isEmpty) return;

    final loadingTimer = Timer(_loadingIndicatorThreshold, () {
      if (emit.isDone) return;
      emit(state.copyWith(status: () => BiblePaneStatus.loading));
    });

    try {
      final newMap = ParallelBibleMap.from(state.content.asMap);
      bool hasAtLeastOneSuccess = false;
      int maxVerseCount = 0;

      final fetchFutures = state.openedBiblesIds.map((id) async {
        final failureOrChapter = await (await _repo).getChapterWithSpans(
          bibleId: id,
          ref: event.ref,
        );
        return MapEntry(id, failureOrChapter);
      });

      final results = await Future.wait(fetchFutures);

      for (var entry in results) {
        final id = entry.key;
        final failureOrChapter = entry.value;

        await failureOrChapter.fold<Future<void>>(
          (fail) async {
            // TODO: get failure details and reason
            newMap[id] = newMap[id]!.copyWith(
              verses: () => null,
            );
          },
          (verses) async {
            hasAtLeastOneSuccess = true;

            // update bible info with verse counter
            // get the greatest count
            final result = (await (await _repo).getMaxVerse(
              ref: event.ref,
              book: event.ref.book,
            ))
                .getOrElse((_) => 0);

            if (result > maxVerseCount) maxVerseCount = result;

            // set content of the pane
            newMap[id] = newMap[id]!.copyWith(
              verses: () => BibleData.versesToMap(verses),
            );
          },
        );
      }

      final content = ParallelBibleConfig.from(newMap);

      if (emit.isDone) return;

      if (hasAtLeastOneSuccess) {
        emit(state.copyWith(
          status: () => BiblePaneStatus.ready,
          reference: () => event.ref,
          content: () => content,
          isMixed: () => false,
          verseCount: () => maxVerseCount,
        ));

        // return feedback to searchbar
        if (!content.isContentEmpty) {
          _navBus?.emit(SearchResultSuccess(
            ref: event.ref,
            source: event.source,
          ));
        }
        _sendTextToObsLiveOverlay(event.ref);
      } else {
        emit(state.copyWith(
          status: () => BiblePaneStatus.error,
          reference: () => event.ref,
          content: () => content,
          isMixed: () => false,
          errorMessage: () => 'Not found in any translation',
          verseCount: () => maxVerseCount,
        ));
      }
    } finally {
      loadingTimer.cancel();
    }
  }

  // TODO: reactive this function later
  void _sendTextToObsLiveOverlay(BibleRef ref) {
    if (_overlayNotifier == null || state.content.isContentEmpty) return;

    // Display content of the first translation
    final translationToDisplay = state.content.keys.first;

    final verses = state.content[translationToDisplay]!.verses!.values
        .where((v) => ref.contains(v.ref))
        .toList();
    final sel = SelectedVerseBusItem(ref: ref, verses: verses);

    _overlayNotifier.update(sel);
  }

  /// Just change the selected verse
  void _onChangeRef(
    BiblePaneJustChangeRef event,
    Emitter<BiblePaneState> emit,
  ) {
    _sendTextToObsLiveOverlay(event.ref);

    if (event.saveHistory) {
      _navBus?.emit(SearchResultSuccess(
        ref: event.ref,
        source: event.source,
      ));
    }

    emit(state.copyWith(reference: () => event.ref));
  }

  Future<void> _onOpenBibleSelection(
    BiblePaneChooseBibles event,
    Emitter<BiblePaneState> emit,
  ) async {
    if (state.openedBiblesIds.isNotEmpty &&
        state.status == BiblePaneStatus.selectBibles) {
      emit(state.copyWith(
        status: () => BiblePaneStatus.ready,
      ));
      return;
    }

    emit(state.copyWith(status: () => BiblePaneStatus.selectBibles));
  }

  FutureOr<void> _onChangeDisplayMode(
      BiblePaneSetDisplayMode event, Emitter<BiblePaneState> emit) {
    emit(state.copyWith(dMode: () => event.dMode));
  }
}
