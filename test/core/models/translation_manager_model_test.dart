import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:the_smyrna_bible_v2/core/data/models/translation_manager_model.dart';
import 'package:the_smyrna_bible_v2/core/data/models/translation_model.dart';
// import 'package:the_smyrna_bible_v2/features/translations_manager/domain/entities/translation.dart';

import 'translation_manager_model_test.mocks.dart';

@GenerateMocks([TranslationManagerModel])
void main() {
  late MockTranslationManagerModel manager;

  setUp(
    () {
      manager = MockTranslationManagerModel();
    },
  );

  const id = 'eng-kjv';
  const translationModel = TranslationModel(
    name: 'king james version',
    abbreviation: 'eng-kjv',
    language: 'english',
    bookNames: {},
  );
  // const Map<String, Translation> localTranslation = {id: translationModel};

  test(
    'should return usfx translation from id',
    () {
      when(manager.getUsfxTranslation(any)).thenReturn(translationModel);

      final result = manager.getUsfxTranslation(id);

      expect(result, translationModel);
    },
  );

  test(
    'should close/remove usfx translation from map',
    () {
      when(manager.closeUsfxTranslation(any));
    },
  );
}
