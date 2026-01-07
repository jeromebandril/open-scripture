import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:archive/archive_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:the_smyrna_bible_v2/core/data/models/verse_span_model.dart';
import 'package:the_smyrna_bible_v2/core/domain/entities/book.dart';
import 'package:the_smyrna_bible_v2/core/database/installation_queries.dart';
import 'package:the_smyrna_bible_v2/core/domain/entities/bible_ref.dart';
import 'package:the_smyrna_bible_v2/core/utils/usfx_parser.dart';
import 'package:the_smyrna_bible_v2/features/bible_installer_manager/domain/entities/bible_download_progress.dart';

import '../../domain/entities/bible_meta.dart';
import '../../database/database.dart' as driftdb;
import '../../domain/entities/verse_span.dart';
import '../../error/exception.dart';
import '../../domain/entities/verse_segment.dart';

abstract class BibleLocalDataSource {
  /// Try to install a translation locally.
  /// It receives a path to the temp_file were the content of
  /// type [List<int>] has been downloaded,
  /// and convert it into expected files/structure.
  ///
  /// Throws a [InstallationException] if it fails
  Stream<InstallProgress> installBible(String bibleId);

  /// Uninstall a local translation (removes files).
  ///
  /// Throws a [InstallationException] if it fails
  Future<void> uninstallBible(String bibleId);

  /// Get a list of installed translations info
  /// as [TranslationInfoModel] object
  ///
  /// Throws a [LocalDataException] if it fails
  Future<List<BibleMeta>> getInstalledBibles();

  /// Get a list of installed translations info
  /// as [TranslationInfoModel] object
  ///
  /// Throws a [LocalDataException] if it fails
  Stream<List<BibleMeta>> watchInstalledBibles();

  /// Get one verse
  ///
  /// Throws a [NoDbConnectionException] if the verse does not exist
  Future<VerseSegment> getVerse(
      int bibleId, String book, int chapter, int verse);

  /// Get a list of verses from a range
  ///
  /// Throws a [NoDbConnectionException] if the verse does not exist
  Future<List<VerseSegment>> getVerseFromRange(
      int bibleId, String bookId, int chapter, int verse);

  /// Get the whole chapter, including the verses
  ///
  /// Throws a [NoDbConnectionException] if the verse does not exist
  Future<List<VerseSegment>> getChapter(
      int bibleId, String bookId, int chapter);

  /// Get the whole chapter, including the verses
  ///
  /// Throws a [NoDbConnectionException] if the verse does not exist
  Future<List<VerseSegment>> getChapterWithSpans(
      int bibleId, String bookId, int chapter);

  /// Get a list of books
  ///
  /// Throws a [NoDbConnectionException] if the verse does not exist
  Future<List<Book>> getBooks(String version);
}

class BibleLocalDatasourceImpl implements BibleLocalDataSource {
  final driftdb.AppDb db;

  BibleLocalDatasourceImpl({required this.db});

  /*
  * New Implementation using SQL Lite as main storage system
  */
  @override
  Future<List<BibleMeta>> getInstalledBibles() async {
    List<driftdb.GetBiblesResult> rows = await db.getBibles().get();

    return rows
        .map((r) => BibleMeta(
              id: r.id,
              extId: r.extId,
              bibleName: r.bibleName,
              abbreviation: r.bibleNameAbbreviation,
              langEngName: r.langEngName,
              langIsoCode: r.langIsoCode,
              langNativeName: r.langNativeName,
            ))
        .toList();
  }

  @override
  Stream<InstallProgress> installBible(String bibleId) async* {
    File? zipFile;
    try {
      yield const InstallProgress(
        stage: InstallStage.installing,
        received: 0,
        total: 5,
        message: 'Preparing installation...',
      );

      // 1) Locate zip (deterministic path)
      final appSupDir = await getApplicationSupportDirectory();
      final dir = Directory(p.join(appSupDir.path, bibleId));
      zipFile = File(p.join(dir.path, '$bibleId.zip')); // <-- prefer .zip

      yield const InstallProgress(
        stage: InstallStage.installing,
        received: 1,
        total: 5,
        message: 'Reading downloaded file...',
      );

      final zipBytes = await zipFile.readAsBytes();

      // 2) Decode zip
      yield const InstallProgress(
        stage: InstallStage.installing,
        received: 2,
        total: 5,
        message: 'Opening archive...',
      );

      final archive = ZipDecoder().decodeBytes(zipBytes);

      String? bibleContent;
      String? metadataContent;

      for (final file in archive) {
        if (!file.isFile) continue;

        final name = file.name;

        // archive package exposes content as bytes for files
        final contentBytes = file.content as List<int>;

        // Identify USFX and metadata robustly
        if (name.endsWith('_usfx.xml') || name.endsWith('usfx.xml')) {
          bibleContent = utf8.decode(contentBytes);
        } else if (name.endsWith('metadata.xml') ||
            name.endsWith('_metadata.xml')) {
          metadataContent = utf8.decode(contentBytes);
        }
      }

      if (bibleContent == null || bibleContent.isEmpty) {
        throw InstallationException(); // or a more specific one
      }
      if (metadataContent == null || metadataContent.isEmpty) {
        throw InstallationException();
      }

      // 3) Parse
      yield const InstallProgress(
        stage: InstallStage.installing,
        received: 3,
        total: 5,
        message: 'Parsing bible content...',
      );

      final usfxParser = UsfxParser(bibleContent, metadataContent);
      final bible = usfxParser.getBible();
      final books = usfxParser.getBooks();
      final verseWithSpans = usfxParser.getVersesWithSpans();

      // final books = usfxParser.getBooks();
      // final verses = usfxParser.getVerses();

      // 4) Insert into DB (placeholder)
      yield const InstallProgress(
        stage: InstallStage.installing,
        received: 4,
        total: 5,
        message: 'Writing to database...',
      );

      // TODO: transaction insert:
      // await db.transaction(() async { ... });
      await db.insertBible(bible, books, verseWithSpans.$1, verseWithSpans.$2);

      // 5) Cleanup
      yield const InstallProgress(
        stage: InstallStage.installing,
        received: 5,
        total: 5,
        message: 'Cleaning up...',
      );

      // Use async delete (don’t use deleteSync in async code)
      await zipFile.delete().catchError((_) {});

      yield const InstallProgress(
        stage: InstallStage.done,
        received: 1,
        total: 1,
        message: 'Installed',
      );
    } catch (e) {
      print(e);
      yield InstallProgress(
        stage: InstallStage.failed,
        received: 0,
        total: 0,
        message: 'Installation failed',
      );
    }

    // try {
    //   final appSupDir = await getApplicationSupportDirectory();
    //   final File rawFile = File("${appSupDir.path}/$bibleId/temp.txt");
    //   final bytes = await rawFile.readAsBytes();

    //   // convert raw file into usfx.xml file format
    //   // should find both metadata.xml and translation_usfx.xml
    //   var bibleContent = '';
    //   var metadataContent = '';
    //   final Archive archive = ZipDecoder().decodeBytes(bytes);

    //   for (final ArchiveFile file in archive) {
    //     if (file.name == '${bibleId}_usfx.xml') {
    //       bibleContent = file.content;
    //     }
    //     if (file.name == '${bibleId}metadata.xml') {
    //       metadataContent = file.content;
    //     }
    //   }

    //   // insert into db, start transaction
    //   final usfxParser = UsfxParser(bibleContent, metadataContent);
    //   final bible = usfxParser.getBible();
    //   //final books = usfxParser.getBooks();
    //   //final verses = usfxParser.getVerses();

    //   // delete the temp file
    //   rawFile.deleteSync();
    // } catch (e) {
    //   throw InstallationException();
    // }
  }

  @override
  Future<void> uninstallBible(String bibleId) async {
    try {
      await (db.delete(db.bibles)..where((b) => b.extId.equals(bibleId))).go();
    } catch (e) {
      throw UninstallationException();
    }
  }

  @override
  Future<List<Book>> getBooks(String version) {
    // TODO: implement getBooks
    throw UnimplementedError();
  }

  @override
  Future<List<VerseSegment>> getChapter(
      int bibleId, String bookId, int chapter) async {
    try {
      final rows =
          await db.getVerseSegmentsForChapter(bibleId, bookId, chapter).get();

      if (rows.isEmpty) throw NotFoundException();

      return rows
          .map((r) => VerseSegment(
                bibleId: bibleId,
                ref: BibleRef(
                  bookOsisId: bookId,
                  chapter: r.chapterNumber,
                  verseStart: r.verseNumber,
                ),
                segmentIndex: r.segmentIndex,
                paragraphStart: r.paragraphStart == 1,
                textContent: r.textContent,
                subtitle: r.subtitle,
                spans: const [],
              ))
          .toList();
    } catch (e) {
      throw LocalDataException();
    }
  }

  @override
  Future<VerseSegment> getVerse(
      int bibleId, String book, int chapter, int verse) {
    // TODO: implement getVerse
    throw UnimplementedError();
  }

  @override
  Future<List<VerseSegment>> getVerseFromRange(
      int bibleId, String bookId, int chapter, int verse) {
    // TODO: implement getVerse
    throw UnimplementedError();
  }

  @override
  Stream<List<BibleMeta>> watchInstalledBibles() {
    throw UnimplementedError();
  }

  @override
  Future<List<VerseSegment>> getChapterWithSpans(
      int bibleId, String bookId, int chapter) async {
    try {
      final rows = await db
          .getSegmentsForChapterWithSpans(bibleId, bookId, chapter)
          .get();

      if (rows.isEmpty) throw NotFoundException();

      final List<VerseSegment> segments = [];
      for (final r in rows) {
        final List<dynamic> raw = jsonDecode(r.spansJson) as List<dynamic>;

        final spans = raw
            .cast<Map<String, dynamic>>()
            .map(VerseSpanModel.fromJson)
            .toList();

        segments.add(VerseSegment(
          bibleId: bibleId,
          ref: BibleRef(
            bookOsisId: bookId,
            chapter: r.chapterNumber,
            verseStart: r.verseNumber,
          ),
          segmentIndex: r.segmentIndex,
          paragraphStart: r.paragraphStart == 1,
          textContent: r.textContent,
          subtitle: r.subtitle,
          spans: spans,
        ));
      }

      return segments;
    } catch (e) {
      throw LocalDataException();
    }
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
