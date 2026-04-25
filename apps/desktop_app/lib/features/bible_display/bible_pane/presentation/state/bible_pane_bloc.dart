import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_scripture/features/obs_live_overlay/domain/entities/overlay_models.dart';
import 'package:open_scripture/shared/entities/book_names.dart';
import 'package:open_scripture/shared/entities/verse.dart';
import 'package:open_scripture/features/bible_display/bible_pane/domain/repositories/bible_pane_repository.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/models/display_mode.dart';
import 'package:open_scripture/core/infrastructure/event_bus/navigation_bus.dart';
import 'package:open_scripture/shared/typedefs.dart';
import 'package:open_scripture/core/infrastructure/event_bus/selected_verse_bus.dart';

import '../../../../../injection_container.dart';
import '../../../../../shared/entities/bible_ref.dart';
import '../models/parallel_bible_config.dart';

part 'bible_pane_event.dart';
part 'bible_pane_state.dart';

class BiblePaneBloc extends Bloc<BiblePaneEvent, BiblePaneState> {
  BiblePaneBloc({
    required int paneId,
    required this.repo,
    SelectedVerseBus? notifier,
    NavigationBus? navBus,
  })  : _navBus = navBus,
        _overlayNotifier = notifier,
        super(BiblePaneState(
            paneId: paneId, status: BiblePaneStatus.selectBibles)) {
    on<BiblePaneOpen>(_onBiblePaneOpen);
    on<BiblePaneDisplayChapter>(_onBiblePaneDisplayChapter);
    on<BiblePaneJustChangeRef>(_onChangeRef);
    on<BiblePaneChooseBibles>(_onClosePane);
    on<BiblePaneDisplayVerses>(_onDisplayVerses);
    on<BiblePaneSetDisplayMode>(_onChangeDisplayMode);
  }

  final BiblePaneRepository repo;
  final NavigationBus? _navBus;
  final SelectedVerseBus? _overlayNotifier;
  final _resolver = sl<BibleRefResolver>();

  // Add a bible translation to the content
  Future<void> _onBiblePaneOpen(
    BiblePaneOpen event,
    Emitter<BiblePaneState> emit,
  ) async {
    emit(state.copyWith(status: () => BiblePaneStatus.loading));

    final newMap = Map<BibleId, ParallelBibleData>.from(state.content.asMap);

    for (final id in event.bibleIds) {
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
          if (newMap[id] == null) {
            newMap[id] = ParallelBibleData(meta: bm);

            // fetch and update content if reference is not null
            if (state.reference != null) {
              add(BiblePaneDisplayChapter(ref: state.reference!));
            }
          }
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
    ));
  }

  /// Display passed bible refs
  Future<void> _onDisplayVerses(
    BiblePaneDisplayVerses event,
    Emitter<BiblePaneState> emit,
  ) async {
    if (state.openedBiblesIds.isEmpty) return;

    final newMap = Map<BibleId, ParallelBibleData>.from(state.content.asMap);

    for (var id in state.openedBiblesIds) {
      final result = await repo.getVersesSegmentsWithSpans(
        bibleId: id,
        refs: event.refs,
      );

      result.fold(
        (_) => newMap[id] = newMap[id]!.copyWith(
          verses: () => null,
        ),
        (s) => newMap[id] = newMap[id]!.copyWith(
          verses: () => Verse.groupMixedSegmentsIntoVerses(s),
        ),
      );
    }

    emit(state.copyWith(
      status: () => BiblePaneStatus.ready,
      content: () => ParallelBibleConfig.from(newMap),
      isMixed: () => true,
    ));
  }

  /// Display the verses of the whole selected chapter
  Future<void> _onBiblePaneDisplayChapter(
    BiblePaneDisplayChapter event,
    Emitter<BiblePaneState> emit,
  ) async {
    if (state.openedBiblesIds.isEmpty) return;

    final newMap = Map<BibleId, ParallelBibleData>.from(state.content.asMap);
    bool isSuccess = false;
    int verseCount = 0;

    for (var id in state.openedBiblesIds) {
      final failureOrChapter = event.withSpans
          ? await repo.getChapterWithSpans(
              bibleId: id,
              reference: event.ref,
            )
          : await repo.getChapterSegments(
              bibleId: id,
              reference: event.ref,
            );

      await failureOrChapter.fold<Future<void>>(
        (f) async => emit(state.copyWith(
          status: () => BiblePaneStatus.error,
          reference: () => event.ref,
          errorMessage: () => f.message,
        )),
        (s) async {
          isSuccess = true;

          // update bible info with verse counter
          // get the greatest count
          final result = (await repo.getMaxVerse(
            reference: event.ref,
            bibleId: id,
          ))
              .getOrElse(
            (_) => 0,
          );
          if (result > verseCount) verseCount = result;

          // set content of the pane
          newMap[id] = newMap[id]!.copyWith(
            verses: () => Verse.groupMixedSegmentsIntoVerses(s),
          );
        },
      );
    }

    final content = ParallelBibleConfig.from(newMap);

    if (isSuccess) {
      emit(state.copyWith(
        status: () => BiblePaneStatus.ready,
        reference: () => event.ref,
        content: () => content,
        isMixed: () => false,
        verseCount: () => verseCount,
      ));

      // return feedback to searchbar
      _navBus?.emit(NavigationFeedback(
        ref: event.ref,
        success: true,
        source: event.source,
      ));

      _sendTextToObsLiveOverlay(event.ref);
    } else {
      emit(state.copyWith(
        status: () => BiblePaneStatus.error,
        reference: () => event.ref,
        content: () => content,
        isMixed: () => false,
        errorMessage: () => 'Not found',
        verseCount: () => verseCount,
      ));
    }
  }

  void _sendTextToObsLiveOverlay(BibleRef ref) {
    if (_overlayNotifier == null || state.content.isContentEmpty) return;

    // Set the bible reference
    String refStr = ref.toString().replaceAll(
          ref.bookUsfxId,
          _resolver.resolveBook(ref.bookUsfxId)!.fullName,
        );

    // Set content
    final buffer = StringBuffer();
    final rangeToDisplay = state.content.getRefsInRange(ref);

    // TODO: support parallel view (e.g. multiple translations in the overlay)
    // For now display content of the first translation
    final translationToDisplay = state.content.keys.first;
    final verses = state.content[translationToDisplay]!.verses!.entries
        .where((e) => rangeToDisplay.contains(e.key))
        .toList();
    for (final v in verses) {
      buffer.write(v.value.text);
    }

    final snapshot = OverlaySnapshot(items: {
      'ref': OverlayItem(text: refStr, visible: true),
      'content': OverlayItem(text: buffer.toString(), visible: true)
    });
    _overlayNotifier.update(snapshot);
  }

  /// Just change the selected verse
  void _onChangeRef(
    BiblePaneJustChangeRef event,
    Emitter<BiblePaneState> emit,
  ) {
    _sendTextToObsLiveOverlay(event.ref);

    if (event.saveHistory) {
      _navBus?.emit(NavigationFeedback(
        ref: event.ref,
        success: true,
        source: event.source,
      ));
    }

    emit(state.copyWith(reference: () => event.ref));
  }

  Future<void> _onClosePane(
    BiblePaneChooseBibles event,
    Emitter<BiblePaneState> emit,
  ) async {
    emit(state.copyWith(
      status: () => BiblePaneStatus.selectBibles,
      //content: () => ParallelBibleConfig.empty,
    ));
  }

  FutureOr<void> _onChangeDisplayMode(
      BiblePaneSetDisplayMode event, Emitter<BiblePaneState> emit) {
    emit(state.copyWith(dMode: () => event.dMode));
  }
}
