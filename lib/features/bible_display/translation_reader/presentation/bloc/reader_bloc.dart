import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_smyrna_bible_v2/core/utils/bible_reference_parser.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/domain/usecases/get_translation.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/domain/usecases/read_chapter.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/domain/usecases/open_usfx_translation.dart';

import '../../../../translations_installer_manager/domain/entities/translation.dart';
import '../../../searchbar/domain/entity/bible_reference.dart';

part 'reader_event.dart';
part 'reader_state.dart';

class ReaderBloc extends Bloc<ReaderEvent, ReaderState> {
  final OpenUsfxTranslation openTranslation;
  // final CloseUsfxTranslation closeTranslation;
  final ReadChapter readChapter;
  final BibleReferenceParser parser;
  final GetTranslation getTranslation;

  ReaderBloc({
    required this.openTranslation,
    // required this.closeTranslation,
    required this.readChapter,
    required this.parser,
    required this.getTranslation,
  }) : super(const ReaderState()) {
    on<ReaderLoadTranslation>(_onLoadTranslation);
    on<ReaderSetContent>(_onSetContent);
  }

  Future<void> _onLoadTranslation(
    ReaderLoadTranslation event,
    Emitter<ReaderState> emit,
  ) async {
    emit(state.copyWith(status: () => ReaderStatus.reading));

    final eitherFailureOrTranslation = await openTranslation(event.id);
    eitherFailureOrTranslation.fold(
      (failure) => print(
        "> BReader: error while loading translation",
      ), //emit(state.copyWith(status: () => ReaderStatus.error)),
      (translation) {
        return emit(
          state.copyWith(
            status: () => ReaderStatus.success,
            TEMP_TRANSLATION: () => translation,
          ),
        );
      },
    );
  }

  Future<void> _onSetContent(
    ReaderSetContent event,
    Emitter<ReaderState> emit,
  ) async {
    // final eitherFailureOrReference = parser.analyze(event.text);

    // return eitherFailureOrReference.fold(
    final eitherFailureOrChapter = await readChapter(event.ref);
    return eitherFailureOrChapter.fold(
      (_) => print('> BReader: error'),
      (verses) => emit(
        state.copyWith(
          status: () => ReaderStatus.success,
          reference: () => event.ref,
          references: () => verses,
        ),
      ),
    );
  }
}
