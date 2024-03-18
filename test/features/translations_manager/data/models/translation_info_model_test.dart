import 'package:flutter_test/flutter_test.dart';
import 'package:the_smyrna_bible_v2/features/translations_manager/data/models/translation_info_model.dart';

// bho non so come testare

void main() {
  const translationInfoModel = TranslationInfoModel(
    id: 'eng-kjv',
    name: 'King james version',
    language: 'english',
  );

  test(
    'should return true if translation is already installed',
    () {
      const isInstalled = true;

      translationInfoModel.checkIfAlreadyInstalled();
    },
  );

  test(
    'should return false if translation is not installed',
    () {},
  );
}
