import 'dart:io';

import 'package:the_smyrna_bible_v2/core/constants/constants.dart';
import 'package:the_smyrna_bible_v2/core/error/exception.dart';

import '../../../../../core/models/translation_model.dart';

abstract class TranslationsDataSource {
  /// Gets a choosen local saved [TranslationModel] to read
  ///
  /// Throws a [NoLocalDataException] if the translation is not present.
  Future<TranslationModel> getTranslation(String id);
}

class TranslationsDataSourceImpl implements TranslationsDataSource {
  TranslationsDataSourceImpl();

  @override
  Future<TranslationModel> getTranslation(String id) async {
    try {
      final path = await ApplicationConstants.getApplicationPath();
      final sourceFile = File('$path/$id/${id}_usfx.xml');
      final metadataFile = File('$path/$id/${id}metadata.xml');

      if (!await sourceFile.exists() || !await metadataFile.exists()) {
        throw NoLocalDataException();
      }

      final sourceXml = await sourceFile.readAsString();
      final metadataXml = await metadataFile.readAsString();

      return TranslationModel.fromUSFX(metadataXml, sourceXml);
    } catch (e) {
      throw NoLocalDataException();
    }
  }
}
