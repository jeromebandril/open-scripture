// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:the_smyrna_bible_v2/core/error/failure.dart';
import 'package:the_smyrna_bible_v2/core/usecases/usecase.dart';
import 'package:the_smyrna_bible_v2/features/translations_manager/domain/entities/translation_info.dart';
import 'package:the_smyrna_bible_v2/features/translations_manager/domain/repositories/translation_manager_repository.dart';
import 'package:the_smyrna_bible_v2/features/translations_manager/domain/usecases/get_translations_info_list.dart';

import 'get_usfx_translation_test.mocks.dart';

@GenerateMocks([TranslationManagerRepository])
void main() {
  late GetTranslationsInfoList usecase;
  late MockTranslationRepository mockTranslationRepository;

  setUp(
    () {
      mockTranslationRepository = MockTranslationRepository();
      usecase = GetTranslationsInfoList(mockTranslationRepository);
    },
  );

  const infos = [
    TranslationInfo(
        id: 'eng-kjv',
        name: 'King James (Authorized) Version',
        language: 'english'),
    TranslationInfo(id: 'gv', name: 'Giovanni Diodati', language: 'Italian'),
    TranslationInfo(id: 'test', name: 'test', language: 'test'),
  ];

  provideDummy<Either<Failure, List<TranslationInfo>>>(Right(infos));

  test(
    'should get List of available translation (with infos) to download',
    () async {
      when(mockTranslationRepository.getAllTranslationsList()).thenAnswer(
        (_) async => Right(infos),
      );

      final result = await usecase(NoParams());

      expect(result, const Right(infos));
      verify(mockTranslationRepository.getAllTranslationsList());
      verifyNoMoreInteractions(mockTranslationRepository);
    },
  );
}
