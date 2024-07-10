import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_smyrna_bible_v2/core/utils/bible_reference_parser.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/scripture_finder/domain/entity/bible_reference.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/domain/usecases/close_usfx_translation.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/domain/usecases/read_chapter.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/domain/usecases/load_usfx_translation.dart';

part 'reader_event.dart';
part 'reader_state.dart';

class ReaderBloc extends Bloc<ReaderEvent, ReaderState> {
  final ReadUsfxTranslation readTranslation;
  final CloseUsfxTranslation closeTranslation;
  final ReadChapter readChapter;
  final BibleReferenceParser parser;

  ReaderBloc({
    required this.readTranslation,
    required this.closeTranslation,
    required this.readChapter,
    required this.parser,
  }) : super(const ReaderState()) {
    on<ReaderLoadTranslation>(_onLoadTranslation);
    on<ReaderAnalyzePrompt>(_onAnalyzePrompt);
  }

  Future<void> _onLoadTranslation(
    ReaderLoadTranslation event,
    Emitter<ReaderState> emit,
  ) async {
    emit(state.copyWith(status: () => ReaderStatus.reading));

    final eitherFailureOrTranslation = await readTranslation(event.id);
    eitherFailureOrTranslation.fold(
      (failure) => emit(state.copyWith(status: () => ReaderStatus.error)),
      (translation) {
        return emit(
          state.copyWith(
            status: () => ReaderStatus.success,
          ),
        );
      },
    );
  }

  Future<void> _onAnalyzePrompt(
    ReaderAnalyzePrompt event,
    Emitter<ReaderState> emit,
  ) async {
    final eitherFailureOrReference = parser.analyze(event.text);

    return eitherFailureOrReference.fold(
      (l) => emit(state.copyWith(status: () => ReaderStatus.error)),
      (reference) async {
        final eitherFailureOrChapter = await readChapter(reference);
        return eitherFailureOrChapter.fold(
          (_) => print('error'),
          (chapter) => emit(
            state.copyWith(
              status: () => ReaderStatus.success,
              reference: () => reference,
              references: () => [chapter],
            ),
          ),
        );
      },
    );
  }
}
