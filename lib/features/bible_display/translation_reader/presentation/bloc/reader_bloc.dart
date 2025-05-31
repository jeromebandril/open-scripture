import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_smyrna_bible_v2/core/domain/entities/e_verse.dart';
import 'package:the_smyrna_bible_v2/features/b_searchbar/domain/entities/bible_reference.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/domain/repositories/reader_repository.dart';

part 'reader_event.dart';
part 'reader_state.dart';

class ReaderBloc extends Bloc<ReaderEvent, ReaderState> {
  final ReaderRepository repo;

  ReaderBloc({
    required this.repo,
  }) : super(const ReaderState()) {
    // on<ReaderLoadTranslation>(_onLoadTranslation);
    on<ReaderDisplay>(_onReaderDisplay);
  }

  // Future<void> _onLoadTranslation(
  //   ReaderLoadTranslation event,
  //   Emitter<ReaderState> emit,
  // ) async {
  //   emit(state.copyWith(status: () => ReaderStatus.reading));

  //   final eitherFailureOrTranslation = await repo.openTranslation(event.id);
  //   eitherFailureOrTranslation.fold(
  //     (failure) => print(
  //       "> BReader: error while loading translation",
  //     ), //emit(state.copyWith(status: () => ReaderStatus.error)),
  //     (translation) {
  //       return emit(
  //         state.copyWith(
  //           status: () => ReaderStatus.success,
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<void> _onReaderDisplay(
    ReaderDisplay event,
    Emitter<ReaderState> emit,
  ) async {
    final eitherFailureOrChapter = await repo.getVerses(event.bibleRef);
    return eitherFailureOrChapter.fold(
      (_) => print('> BReader: error chapter not read'),
      (verses) => emit(
        state.copyWith(
          status: () => ReaderStatus.success,
          reference: () => event.bibleRef,
          verses: () => verses,
        ),
      ),
    );
  }
}
