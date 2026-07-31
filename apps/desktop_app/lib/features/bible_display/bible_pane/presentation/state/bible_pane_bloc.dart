import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/infrastructure/event_bus/search_result_bus.dart';
import '../../../../../core/infrastructure/event_bus/selected_verse_bus.dart';
import '../../../../../core/settings/settings_repository.dart';
import '../../../../../shared/domain/entities/bible_id.dart';
import '../../../../../shared/domain/entities/bible_ref.dart';
import '../../../../../shared/domain/repositories/bible_pane_repository_factory.dart';
import '../../../../../shared/enums/bible_repository_type.dart';
import '../../../../../shared/error/failure.dart';
import '../../../../my_library/settings/my_library_settings.dart';
import '../../../settings/bible_view_settings.dart';
import '../../domain/display_mode.dart';
import '../../domain/entities/word_info.dart';
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
    required SettingsRepository<BibleViewSettings> viewSettings,
    SettingsRepository<MyLibrarySettings>? libSettings,
    SelectedVerseBus? notifier,
    SearchResultBus? navBus,
  })  : _libSettings = libSettings,
        _repositoryFactory = repositoryFactory,
        _navBus = navBus,
        _overlayNotifier = notifier,
        super(BiblePaneState(
          paneId: paneId,
          status: BiblePaneStatus.selectBibles,
          dMode: viewSettings.current.defaultDisplayMode,
        )) {
    on<BiblePaneOpen>(_onBiblePaneOpen);
    on<BiblePaneDisplayChapter>(_onBiblePaneDisplayChapter);
    on<BiblePaneJustChangeRef>(_onChangeRef);
    on<BiblePaneChooseBibles>(_onOpenBibleSelection);
    on<BiblePaneDisplayVerses>(_onDisplayVerses);
    on<BiblePaneSetDisplayMode>(_onChangeDisplayMode);
    on<BiblePaneSelectWord>(_onSelectWord);

    // It should not be a problem if it causes state flashes
    // TODO: think a better solution instead of calling event
    // immediatly after constructor execution
    _initConfiguration();
  }

  final SearchResultBus? _navBus;
  final SelectedVerseBus? _overlayNotifier;
  final BibleRepositoryFactory _repositoryFactory;
  final SettingsRepository<MyLibrarySettings>? _libSettings;
  // final _resolver = sl<BibleRefResolver>();

  void _initConfiguration() {
    final preferredBibleId = _libSettings?.current.preferredBibleId;
    if (preferredBibleId == null) return;
    add(BiblePaneOpen(bibleIds: [preferredBibleId]));
  }

  Future<BiblePaneRepository> get _repo async =>
      await _repositoryFactory.get(state.repoType);

  Future<void> _onBiblePaneOpen(
    BiblePaneOpen event,
    Emitter<BiblePaneState> emit,
  ) async {
    emit(state.copyWith(status: () => BiblePaneStatus.loading));

    final repoType = event.bibleIds.first.repoType;
    final repo = await _repositoryFactory.get(repoType);
    final newMap = ParallelBibleMap.from(state.content.asMap);
    bool hasAtLeastOneSuccess = false;
    late Failure failure;

    for (final id in event.bibleIds) {
      // check if bible actually exists
      final result = await repo.getBible(bibleId: id).run();

      result.fold(
        (f) {
          failure = f;
        },
        (bm) {
          hasAtLeastOneSuccess = true;
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

    if (hasAtLeastOneSuccess) {
      emit(state.copyWith(
        status: () => BiblePaneStatus.ready,
        content: () => ParallelBibleConfig.from(newMap),
        parallelOrder: () => event.bibleIds,
        isNotSameBookChapter: () => false,
        repoType: () => repoType,
      ));
      // fetch and update content if reference is not null
      if (state.reference == null) return;
      add(BiblePaneDisplayChapter(ref: state.reference!));
    } else {
      emit(state.copyWith(
        status: () => BiblePaneStatus.error,
        errorMessage: () => '${failure.message} ${failure.cause.toString()}',
      ));
    }
  }

  Future<void> _onDisplayVerses(
    BiblePaneDisplayVerses event,
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
      List<Failure> errors = [];
      int maxVerseCount = 0;

      final fetchFutures = state.openedBiblesIds.map((id) async {
        final failureOrChapter = await (await _repo)
            .getVerses(
              bibleId: id,
              refs: event.refs,
            )
            .run();
        return MapEntry(id, failureOrChapter);
      });

      final results = await Future.wait(fetchFutures);

      for (var entry in results) {
        final id = entry.key;
        final failureOrChapter = entry.value;

        await failureOrChapter.fold<Future<void>>(
          (failure) async {
            errors.add(failure);
            newMap[id] = newMap[id]!.copyWith(
              verses: () => null,
            );
          },
          (verses) async {
            hasAtLeastOneSuccess = true;

            // update bible info with verse counter
            // get the greatest count
            final verseCount = verses.length;
            if (verseCount > maxVerseCount) maxVerseCount = verseCount;

            // set content of the pane
            newMap[id] = newMap[id]!.copyWith(
              verses: () => BibleData.versesToMap(verses, preserveOrder: true),
            );
          },
        );
      }

      final content = ParallelBibleConfig.from(newMap);

      if (emit.isDone) return;

      if (hasAtLeastOneSuccess) {
        emit(state.copyWith(
          status: () => BiblePaneStatus.ready,
          reference: () => event.refs.first,
          content: () => content,
          isNotSameBookChapter: () => true,
          verseCount: () => maxVerseCount,
        ));
        // return feedback to searchbar
        if (!content.isContentEmpty) {
          _navBus?.emit(SearchResultSuccess(
            ref: event.refs.first,
            // source: event.,
          ));
        }
        // _sendTextToObsLiveOverlay(event.ref);
      } else {
        emit(state.copyWith(
          status: () => BiblePaneStatus.error,
          reference: () => event.refs.first,
          content: () => content,
          isNotSameBookChapter: () => true,
          errorMessage: () => errors.first.message,
          verseCount: () => maxVerseCount,
        ));
      }
    } finally {
      loadingTimer.cancel();
    }
  }

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
      List<Failure> errors = [];
      int maxVerseCount = 0;

      final fetchFutures = state.openedBiblesIds.map((id) async {
        final failureOrChapter = await (await _repo)
            .getChapter(
              bibleId: id,
              ref: event.ref,
            )
            .run();
        return MapEntry(id, failureOrChapter);
      });

      final results = await Future.wait(fetchFutures);

      for (var entry in results) {
        final id = entry.key;
        final failureOrChapter = entry.value;

        await failureOrChapter.fold<Future<void>>(
          (failure) async {
            errors.add(failure);
            newMap[id] = newMap[id]!.copyWith(
              verses: () => null,
            );
          },
          (verses) async {
            hasAtLeastOneSuccess = true;

            // update bible info with verse counter
            // get the greatest count
            final verseCount = verses.length;
            if (verseCount > maxVerseCount) maxVerseCount = verseCount;

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
          isNotSameBookChapter: () => false,
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
          isNotSameBookChapter: () => false,
          errorMessage: () => errors.first.message,
          verseCount: () => maxVerseCount,
        ));
      }
    } finally {
      loadingTimer.cancel();
    }
  }

  void _sendTextToObsLiveOverlay(BibleRef ref) {
    // TODO: should not execute if feature is not running/enabled
    if (_overlayNotifier == null || state.content.isContentEmpty) return;

    // Display content of the first translation available
    for (final content in state.content.asMap.values) {
      final verses = content.verses?.values
          .where((verse) => ref.contains(verse.ref))
          .toList();

      if (verses != null && verses.isNotEmpty) {
        _overlayNotifier.update(
          SelectedVerseBusItem(
            ref: ref,
            verses: verses,
          ),
        );
        return;
      }
    }
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

  void _onSelectWord(BiblePaneSelectWord event, Emitter<BiblePaneState> emit) =>
      emit(state.copyWith(selectedWord: () => event.word));
}
