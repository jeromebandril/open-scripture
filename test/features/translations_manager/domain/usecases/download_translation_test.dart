import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:the_smyrna_bible_v2/core/error/failure.dart';
import 'package:the_smyrna_bible_v2/core/models/translation_model.dart';
import 'package:the_smyrna_bible_v2/core/usecases/usecase.dart';
import 'package:the_smyrna_bible_v2/features/translations_manager/domain/entities/translation.dart';
import 'package:the_smyrna_bible_v2/features/translations_manager/domain/repositories/translation_manager_repository.dart';
import 'package:the_smyrna_bible_v2/features/translations_manager/domain/usecases/download_translation.dart';

import 'get_usfx_translation_test.mocks.dart';

@GenerateMocks([TranslationManagerRepository])
void main() {
  late DownloadTranslation usecase;
  late MockTranslationRepository mockTranslationRepository;

  setUp(
    () {
      mockTranslationRepository = MockTranslationRepository();
      usecase = DownloadTranslation(mockTranslationRepository);
    },
  );

  const translation = TranslationModel(
    name: 'king james version',
    abbreviation: 'eng-kjv',
    language: 'english',
    bookNames: {},
  );

  const id = "eng-kjv";

  provideDummy<Either<Failure, Translation>>(const Right(translation));

  test(
    'should install translationModel into local system',
    () async {
      when(mockTranslationRepository.downloadTranslation(any)).thenAnswer(
        (_) async => const Right(translation),
      );

      final result = await usecase(const Params(id: id));

      expect(result, const Right(translation));
      verify(mockTranslationRepository.downloadTranslation(id));
      verifyNoMoreInteractions(mockTranslationRepository);
    },
  );
}
