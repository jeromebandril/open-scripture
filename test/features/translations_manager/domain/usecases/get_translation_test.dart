// ignore_for_file: prefer_const_constructors

import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:the_smyrna_bible_v2/core/error/failure.dart';
import 'package:the_smyrna_bible_v2/core/usecases/usecase.dart';
import 'package:the_smyrna_bible_v2/features/translations_manager/domain/entities/translation.dart';
import 'package:the_smyrna_bible_v2/features/translations_manager/domain/repositories/translation_manager_repository.dart';
import 'package:the_smyrna_bible_v2/features/translations_manager/domain/usecases/get_local_translation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'get_usfx_translation_test.mocks.dart';

@GenerateMocks([TranslationManagerRepository])
void main() {
  late GetUsfxTranslation usecase;
  late MockTranslationRepository mockTranslationRepository;

  setUp(() {
    mockTranslationRepository = MockTranslationRepository();
    usecase = GetUsfxTranslation(mockTranslationRepository);
  });

  const a = 'kjv';
  const translation = Translation(
    name: 'king james version',
    abbreviation: 'kjv',
    language: 'english',
    bookNames: {},
  );
  provideDummy<Either<Failure, Translation>>(Right(translation));

  test(
    'should get USFX translation from repository',
    () async {
      // arrange

      when(mockTranslationRepository.getLocalUsfxTranslation(any))
          .thenAnswer((_) async => Right(translation));

      // act
      final result = await usecase(const Params(id: a));

      // assert
      expect(result, Right(translation));
      verify(mockTranslationRepository.getLocalUsfxTranslation(a));
      verifyNoMoreInteractions(mockTranslationRepository);
    },
  );
}
