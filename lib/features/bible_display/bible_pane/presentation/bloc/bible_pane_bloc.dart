import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_smyrna_bible_v2/core/domain/entities/verse_segment.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_pane/domain/repositories/bible_repository.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_pane/presentation/navigation_bus.dart';

import '../../../../../core/domain/entities/bible_meta.dart';
import '../../../../../core/domain/entities/bible_ref.dart';

part 'bible_pane_event.dart';
part 'bible_pane_state.dart';

class BiblePaneBloc extends Bloc<BiblePaneEvent, BiblePaneState> {
  BiblePaneBloc({
    required int paneId,
    required this.repo,
    NavigationBus? navBus,
  })  : _navBus = navBus,
        super(BiblePaneState(paneId: paneId, status: BiblePaneStatus.initial)) {
    on<BiblePaneOpen>(_onBiblePaneOpen);
    on<BiblePaneDisplayChapter>(_onBiblePaneDisplayChapter);
    on<BiblePaneJustChangeRef>(_onChangeRef);
    on<BiblePaneCloseBible>(_onCloseBible);
    on<BiblePaneDisplayVerses>(_onDisplayVerses);
  }

  final BibleRepository repo;
  final NavigationBus? _navBus;

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
        verseSegments: () => segments,
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
      (verses) {
        emit(state.copyWith(
          status: () => BiblePaneStatus.ready,
          reference: () => event.ref,
          verseSegments: () => verses,
          isMixed: () => false,
        ));

        _navBus?.emit(NavigationFeedback(
          ref: event.ref,
          success: true,
          source: event.source,
        ));
      },
    );
  }

  void _onChangeRef(
    BiblePaneJustChangeRef event,
    Emitter<BiblePaneState> emit,
  ) {
    final vn = event.ref.verseStart;
    if (vn == null || vn < 1 || vn > state.segments.last.ref.verseStart!) {
      return;
    }

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
}
