import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:the_smyrna_bible_v2/core/data/models/translation_model.dart';
import 'package:the_smyrna_bible_v2/features/translations_manager/domain/repositories/translation_manager_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:the_smyrna_bible_v2/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_smyrna_bible_v2/features/translations_manager/domain/usecases/install_translation.dart';

import 'get_usfx_translation_test.mocks.dart';

@GenerateMocks([TranslationManagerRepository])
void main() {
  late InstallUsfxTranslation usecase;
  late MockTranslationRepository mockTranslationRepository;

  setUp(
    () {
      mockTranslationRepository = MockTranslationRepository();
      usecase = InstallUsfxTranslation(mockTranslationRepository);
    },
  );

  const translation = TranslationModel(
    name: 'king james version',
    abbreviation: 'kjv',
    language: 'english',
    bookNames: {},
  );

  const isSuccess = true;

  provideDummy<Either<Failure, bool>>(const Right(isSuccess));
  test(
    'should install translationModel into local system',
    () async {
      when(mockTranslationRepository.installTranslation(any)).thenAnswer(
        (_) async => const Right(isSuccess),
      );

      final result = await usecase(translation);

      expect(result, const Right(isSuccess));
      verify(mockTranslationRepository.installTranslation(translation));
      verifyNoMoreInteractions(mockTranslationRepository);
    },
  );
}
