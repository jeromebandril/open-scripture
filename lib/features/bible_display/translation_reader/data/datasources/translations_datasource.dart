import 'dart:io';

import 'package:the_smyrna_bible_v2/core/constants/constants.dart';
import 'package:the_smyrna_bible_v2/core/database/database.dart';
import 'package:the_smyrna_bible_v2/core/error/exception.dart';

import '../../../../../core/data/models/book_model.dart';
import '../../../../../core/data/models/translation_model.dart';
import '../../../../../core/data/models/verse_model.dart';

abstract class TranslationsDataSource {
  /// Gets a choosen local saved [TranslationModel] to read.
  ///
  /// Throws a [NoLocalDataException] if the translation is not present.
  Future<TranslationModel> getTranslation(String id);

  /// Read a verse
  ///
  /// Throws a [NoDbConnectionException] if the verse does not exist
  Future<VerseModel> getVerse(
      String version, String book, int chapter, int verse);

  /// Read a verse
  ///
  /// Throws a [NoDbConnectionException] if the verse does not exist
  Future<List<VerseModel>> getChapter(String version, String book, int chapter);

  /// Read a verse
  ///
  /// Throws a [NoDbConnectionException] if the verse does not exist
  Future<List<BookModel>> getBooks(String version);
}

class TranslationsDataSourceImpl implements TranslationsDataSource {
  TranslationsDataSourceImpl({required this.db});

  final AppDb db;

  @override
  Future<TranslationModel> getTranslation(String id) async {
    try {
      print("> BReader: reading from file system");
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

  @override
  Future<List<BookModel>> getBooks(String version) {
    throw UnimplementedError();
  }

  @override
  Future<List<VerseModel>> getChapter(
      String version, String book, int chapter) {
    throw UnimplementedError();
  }

  @override
  Future<VerseModel> getVerse(
      String version, String book, int chapter, int verse) {
    throw UnimplementedError();
  }
}
