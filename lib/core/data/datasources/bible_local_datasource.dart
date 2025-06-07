import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:the_smyrna_bible_v2/core/data/models/book_model.dart';
import 'package:the_smyrna_bible_v2/core/utils/usfx_parser.dart';

import '../models/bible_model.dart';
import '../../database/database.dart';
import '../../error/exception.dart';
import '../models/verse_model.dart';

abstract class BibleLocalDataSource {
  /// Try to install a translation locally.
  /// It receives a path to the temp_file were the content of
  /// type [List<int>] has been downloaded,
  /// and convert it into expected files/structure.
  ///
  /// Throws a [InstallationException] if it fails
  Future<void> installBible(String path);

  /// Uninstall a local translation (removes files).
  ///
  /// Throws a [InstallationException] if it fails
  Future<void> uninstallBible(String path);

  /// Get a list of installed translations info
  /// as [TranslationInfoModel] object
  ///
  /// Throws a [NoLocalDataException] if it fails
  Future<List<BibleModel>> getInstalledBibles();

  /// Get one verse
  ///
  /// Throws a [NoDbConnectionException] if the verse does not exist
  Future<VerseModel> getVerse(
      String version, String book, int chapter, int verse);

  /// Get a list of verses from a range
  ///
  /// Throws a [NoDbConnectionException] if the verse does not exist
  Future<List<VerseModel>> getVerseRange(
      String version, String book, int chapter, int verse);

  /// Get the whole chapter, including the verses
  ///
  /// Throws a [NoDbConnectionException] if the verse does not exist
  Future<List<VerseModel>> getChapter(String version, String book, int chapter);

  /// Get a list of books
  ///
  /// Throws a [NoDbConnectionException] if the verse does not exist
  Future<List<BookModel>> getBooks(String version);
}

class BibleLocalDatasourceImpl implements BibleLocalDataSource {
  final AppDb db;

  BibleLocalDatasourceImpl({required this.db});

  /*
  * New Implementation using SQL Lite as main storage system
  */
  @override
  Future<List<BibleModel>> getInstalledBibles() async {
    List<GetBiblesResult> result = await db.getBibles().get();
    const List<BibleModel> bibles = [];

    for (var item in result) {
      bibles.add(BibleModel.fromDatabase(item));
    }

    return bibles;
  }

  @override
  Future<void> installBible(String bibleId) async {
    try {
      final appSupDir = await getApplicationSupportDirectory();
      final File rawFile = File("${appSupDir.path}/$bibleId/temp.txt");
      final bytes = await rawFile.readAsBytes();

      // convert raw file into usfx.xml file format
      // should find both metadata.xml and translation_usfx.xml
      var bibleContent = '';
      var metadataContent = '';
      final Archive archive = ZipDecoder().decodeBytes(bytes);

      for (final ArchiveFile file in archive) {
        if (file.name == '${bibleId}_usfx.xml') {
          bibleContent = file.content;
        }
        if (file.name == '${bibleId}metadata.xml') {
          metadataContent = file.content;
        }
      }

      // insert into db, start transaction
      final usfxParser = UsfxParser(bibleContent, metadataContent);
      final bible = usfxParser.getBible();
      //final books = usfxParser.getBooks();
      //final verses = usfxParser.getVerses();

      // delete the temp file
      rawFile.deleteSync();
    } catch (e) {
      throw InstallationException();
    }
  }

  @override
  Future<void> uninstallBible(String path) {
    // TODO: implement uninstallTranslation
    throw UnimplementedError();
  }

  @override
  Future<List<BookModel>> getBooks(String version) {
    // TODO: implement getBooks
    throw UnimplementedError();
  }

  @override
  Future<List<VerseModel>> getChapter(
      String version, String book, int chapter) {
    // TODO: implement getChapter
    throw UnimplementedError();
  }

  @override
  Future<VerseModel> getVerse(
      String version, String book, int chapter, int verse) {
    // TODO: implement getVerse
    throw UnimplementedError();
  }

  @override
  Future<List<VerseModel>> getVerseRange(
      String version, String book, int chapter, int verse) {
    // TODO: implement getVerseRange
    throw UnimplementedError();
  }

  // ************************************************************************
  // Old implementation with direct read/write from the filesystem and managing
  // manually the files
  //************************************************************************* */
  /*
  @override
  Future<void> installTranslation(String id) async {
    try {
      final path = await ApplicationConstants.getApplicationPath();
      File rawFile = File("$path/$id/temp.txt");
      final bytes = await rawFile.readAsBytes();

      // convert raw file into usfx.xml file format
      // should find both metadata.xml and translation_usfx.xml
      File goodFile = File('$path/$id/${id}_usfx.xml');
      File metadataFile = File('$path/$id/${id}metadata.xml');
      final Archive archive = ZipDecoder().decodeBytes(bytes);

      for (final ArchiveFile file in archive) {
        if (file.name == '${id}_usfx.xml') {
          goodFile.writeAsBytesSync(file.content);
        }
        if (file.name == '${id}metadata.xml') {
          metadataFile.writeAsBytesSync(file.content);
        }
      }

      // delete the temp file
      rawFile.deleteSync();
    } catch (e) {
      throw InstallationException();
    }
  }

  @override
  Future<void> uninstallTranslation(String id) async {
    try {
      final path = await ApplicationConstants.getApplicationPath();
      Directory directory = Directory("$path/$id");
      directory.delete(recursive: true);
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<TranslationInfoModel>> getInstalledTransationInfos() async {
    try {
      final appDir = Directory(
        await ApplicationConstants.getApplicationPath(),
      );
      final subDirs = await appDir.list().toList();
      final List<TranslationInfoModel> infos = [];

      for (var sd in subDirs) {
        String ok = sd.path;
        infos.add(
          TranslationInfoModel(
            id: ok,
            name: ok,
            language: ok,
          ),
        );
      }

      return infos;
    } catch (e) {
      throw NoLocalDataException();
    }
  }
  */
}
