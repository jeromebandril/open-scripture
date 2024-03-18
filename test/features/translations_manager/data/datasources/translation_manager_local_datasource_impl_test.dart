import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:the_smyrna_bible_v2/core/error/exception.dart';
import 'package:the_smyrna_bible_v2/core/models/translation_model.dart';
import 'package:the_smyrna_bible_v2/features/translations_manager/data/datasources/translation_manager_local_datasource.dart';

import 'translation_local_datasource_impl_test.mocks.dart';

// import 'translation_local_datasource_impl_test.mocks.dart';

@GenerateMocks([TranslationManagerLocalDataSourceImpl, File])
void main() {
  late MockTranslationManagerLocalDataSourceImpl dataSource;

  setUp(() {
    dataSource = MockTranslationManagerLocalDataSourceImpl();
  });

  const translationModel = TranslationModel(
    name: '',
    abbreviation: '',
    language: '',
    bookNames: {},
  );

  const id = 'eng-kjv';
  group('get local translation', () {
    test(
      'should get translation model from local data source',
      () async {
        when(dataSource.openLocalUsfxTranslation(any)).thenAnswer(
          (_) async => translationModel,
        );

        final result = await dataSource.openLocalUsfxTranslation(id);

        expect(result, equals(translationModel));
      },
    );

    test(
      'should return NoLocalData exception when the choosen translation is not present',
      () async {
        when(dataSource.openLocalUsfxTranslation(any)).thenThrow(
          NoLocalDataException(),
        );

        expect(
          dataSource.openLocalUsfxTranslation(id),
          throwsA(const TypeMatcher<NoLocalDataException>()),
        );
      },
    );
  });

  group(
    'install translation model locally',
    () {
      test(
        'should return true when install/save the usfx translation locally using path_provider is sucessful',
        () async {
          when(dataSource.installUsxfTranslation(translationModel)).thenAnswer(
            (_) async => true,
          );

          final result =
              await dataSource.installUsxfTranslation(translationModel);

          expect(result, true);
          // verifyNoMoreInteractions(dataSource);
        },
      );

      test(
        'should throw InstallationException when intallation fails',
        () async {
          when(dataSource.installUsxfTranslation(translationModel)).thenThrow(
            InstallationException(),
          );

          var future = dataSource.installUsxfTranslation(translationModel);
          await expectLater(
            future,
            throwsA(isA<InstallationException>),
          );
          // verifyNoMoreInteractions(dataSource);
        },
      );
    },
  );
}
