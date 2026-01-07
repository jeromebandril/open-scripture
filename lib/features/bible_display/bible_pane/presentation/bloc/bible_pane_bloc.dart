import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_smyrna_bible_v2/core/domain/entities/verse_segment.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_pane/domain/repositories/bible_repository.dart';

import '../../../../../core/domain/entities/bible_ref.dart';

part 'bible_pane_event.dart';
part 'bible_pane_state.dart';

class BiblePaneBloc extends Bloc<BiblePaneEvent, BiblePaneState> {
  final BibleRepository repo;

  BiblePaneBloc({
    required int paneId,
    required this.repo,
  }) : super(BiblePaneState(paneId: paneId, status: BiblePaneStatus.initial)) {
    on<BiblePaneOpen>(_onBiblePaneOpen);
    on<BiblePaneDisplayChapter>(_onBiblePaneDisplayChapter);
  }

  Future<void> _onBiblePaneOpen(
    BiblePaneOpen event,
    Emitter<BiblePaneState> emit,
  ) async {
    // TODO: check bible availability first
    emit(state.copyWith(status: () => BiblePaneStatus.loading));
    emit(state.copyWith(
      status: () => BiblePaneStatus.ready,
      bibleId: () => event.bibleId,
    ));
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
      (f) => emit(
        state.copyWith(
          status: () => BiblePaneStatus.error,
          reference: () => event.ref,
        ),
      ),
      (verses) => emit(
        state.copyWith(
          status: () => BiblePaneStatus.ready,
          reference: () => event.ref,
          verseSegments: () => verses,
        ),
      ),
    );
  }
}
