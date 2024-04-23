import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_smyrna_bible_v2/core/utils/bible_reference_parser.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/scripture_finder/domain/entity/bible_reference.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/domain/entities/translation_reader.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/domain/usecases/close_usfx_translation.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/domain/usecases/display_chapter.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/domain/usecases/read_usfx_translation.dart';

part 'reader_event.dart';
part 'reader_state.dart';

class ReaderBloc extends Bloc<ReaderEvent, ReaderState> {
  final ReadUsfxTranslation readTranslation;
  final CloseUsfxTranslation closeTranslation;
  final DisplayChapter displayChapter;
  final BibleReferenceParser parser;

  ReaderBloc({
    required this.readTranslation,
    required this.closeTranslation,
    required this.displayChapter,
    required this.parser,
  }) : super(const ReaderState()) {
    on<ReaderReadTranslation>(_onReadTranslation);
    on<ReaderViewChapter>(_onViewChapter);
  }

  Future<void> _onReadTranslation(
    ReaderReadTranslation event,
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
            viewer: () => TranslationViewer(
              translations: [translation],
            ),
          ),
        );
      },
    );
  }

  Future<void> _onViewChapter(
    ReaderViewChapter event,
    Emitter<ReaderState> emit,
  ) async {
    final eitherFailureOrReference = parser.analyze(event.text);

    return eitherFailureOrReference.fold(
      (l) => emit(state.copyWith(status: () => ReaderStatus.error)),
      (reference) async {
        return emit(
          state.copyWith(
            status: () => ReaderStatus.success,
            reference: () => reference,
            references: () => [reference],
          ),
        );
      },
    );
  }
}
