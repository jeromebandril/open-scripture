import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_scripture/features/obs_live_overlay/domain/entities/overlay_models.dart';
import 'package:open_scripture/shared/domain/entities/book_names.dart';
import 'package:open_scripture/shared/domain/entities/verse_segment.dart';
import 'package:open_scripture/features/bible_display/bible_pane/domain/repositories/bible_repository.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/models/display_mode.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/navigation_bus.dart';
import 'package:open_scripture/shared/presentation/notifiers/selected_verse_content_notifier.dart';

import '../../../../../injection_container.dart';
import '../../../../../shared/domain/entities/bible_meta.dart';
import '../../../../../shared/domain/entities/bible_ref.dart';

part 'bible_pane_event.dart';
part 'bible_pane_state.dart';

class BiblePaneBloc extends Bloc<BiblePaneEvent, BiblePaneState> {
  BiblePaneBloc({
    required int paneId,
    required this.repo,
    ContentOfSelectedVerseNotifier? notifier,
    NavigationBus? navBus,
  })  : _navBus = navBus,
        _overlayNotifier = notifier,
        super(BiblePaneState(paneId: paneId, status: BiblePaneStatus.initial)) {
    on<BiblePaneOpen>(_onBiblePaneOpen);
    on<BiblePaneDisplayChapter>(_onBiblePaneDisplayChapter);
    on<BiblePaneJustChangeRef>(_onChangeRef);
    on<BiblePaneCloseBible>(_onCloseBible);
    on<BiblePaneDisplayVerses>(_onDisplayVerses);
    on<BiblePaneSetDisplayMode>(_onChangeDisplayMode);
  }

  final BibleRepository repo;
  final NavigationBus? _navBus;
  final ContentOfSelectedVerseNotifier? _overlayNotifier;
  final _resolver = sl<BibleRefResolver>();

  Future<void> _onDisplayVerses(
    BiblePaneDisplayVerses event,
    Emitter<BiblePaneState> emit,
  ) async {
    if (state.bibleId == null) return;

    final result = await repo.getVersesSegmentsWithSpans(
      bibleId: state.bibleId!,
      refs: event.refs,
    );

    result.fold(
      (f) => emit(state.copyWith(
        status: () => BiblePaneStatus.error,
        errorMessage: () => f.message,
      )),
      (segments) => emit(state.copyWith(
        status: () => BiblePaneStatus.ready,
        segments: () => segments,
        reference: () => segments.first.ref,
        isMixed: () => true,
      )),
    );
  }

  Future<void> _onBiblePaneOpen(
    BiblePaneOpen event,
    Emitter<BiblePaneState> emit,
  ) async {
    emit(state.copyWith(status: () => BiblePaneStatus.loading));

    final result = await repo.getBibleMetadata(bibleId: event.bibleId);

    result.fold(
      (f) => emit(state.copyWith(
        status: () => BiblePaneStatus.error,
        errorMessage: () => f.message,
      )),
      (bm) => emit(state.copyWith(
          status: () => BiblePaneStatus.ready,
          bibleId: () => event.bibleId,
          bibleMeta: () => bm,
          isMixed: () => false)),
    );
  }

  Future<void> _onBiblePaneDisplayChapter(
    BiblePaneDisplayChapter event,
    Emitter<BiblePaneState> emit,
  ) async {
    if (state.bibleId == null) return;

    final eitherFailureOrChapter = event.withSpans
        ? await repo.getChapterWithSpans(
            bibleId: state.bibleId!,
            reference: event.ref,
          )
        : await repo.getChapterSegments(
            bibleId: state.bibleId!,
            reference: event.ref,
          );

    return eitherFailureOrChapter.fold(
      (f) => emit(state.copyWith(
        status: () => BiblePaneStatus.error,
        reference: () => event.ref,
        errorMessage: () => f.message,
      )),
      (verses) async {
        // update bible info for max verse range
        final int maxVerse = (await repo.getMaxVerse(
          reference: event.ref,
          bibleId: state.bibleId!,
        ))
            .getOrElse(
          (_) => 0,
        );

        // set content of the pane
        emit(state.copyWith(
          status: () => BiblePaneStatus.ready,
          reference: () => event.ref,
          segments: () => verses,
          isMixed: () => false,
          maxVerse: () => maxVerse,
        ));

        _sendTextToObsLiveOverlay(state.segments, event.ref);

        // return feedback to searchbar
        _navBus?.emit(NavigationFeedback(
          ref: event.ref,
          success: true,
          source: event.source,
        ));
      },
    );
  }

  void _sendTextToObsLiveOverlay(List<VerseSegment> segments, BibleRef ref) {
    if (_overlayNotifier == null) return;
    final selVerse =
        segments.where((s) => s.ref.verseStart == ref.verseStart).toList();

    String content = selVerse.map((s) => s.textContent).join(' ');
    String refStr = ref.toString().replaceAll(
          ref.bookUsfxId,
          _resolver.resolveBook(ref.bookUsfxId)!.fullName,
        );

    final snapshot = OverlaySnapshot(items: {
      'ref': OverlayItem(text: refStr, visible: true),
      'content': OverlayItem(text: content, visible: true)
    });
    _overlayNotifier.update(snapshot);
  }

  void _onChangeRef(
    BiblePaneJustChangeRef event,
    Emitter<BiblePaneState> emit,
  ) {
    final vn = event.ref.verseStart;
    if (vn == null || vn < 1 || vn > state.segments.last.ref.verseStart!) {
      return;
    }

    _sendTextToObsLiveOverlay(state.segments, event.ref);

    if (event.saveHistory) {
      _navBus?.emit(NavigationFeedback(
        ref: event.ref,
        success: true,
        source: event.source,
      ));
    }

    emit(state.copyWith(reference: () => event.ref));
  }

  Future<void> _onCloseBible(
    BiblePaneCloseBible event,
    Emitter<BiblePaneState> emit,
  ) async {
    emit(state.copyWith(
      status: () => BiblePaneStatus.initial,
      bibleId: () => null,
    ));
  }

  FutureOr<void> _onChangeDisplayMode(
      BiblePaneSetDisplayMode event, Emitter<BiblePaneState> emit) {
    emit(state.copyWith(dMode: () => event.dMode));
  }
}
