import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:archive/archive_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_scripture/shared/data/models/verse_span_model.dart';
import 'package:open_scripture/shared/domain/entities/book.dart';
import 'package:open_scripture/shared/database/installation_queries.dart';
import 'package:open_scripture/shared/domain/entities/bible_ref.dart';
import 'package:open_scripture/shared/utils/usfx_parser.dart';
import 'package:open_scripture/features/bible_installer_manager/domain/entities/bible_download_progress.dart';

import '../../domain/entities/bible_meta.dart';
import '../../database/database.dart' as driftdb;
import '../../error/exception.dart';
import '../../domain/entities/verse_segment.dart';

abstract class BibleLocalDataSource {
  /// Installs a previously downloaded bible archive into the local store.
  ///
  /// This method assumes the archive has already been downloaded to the
  /// deterministic location used by the remote data source (based on [bibleId]).
  ///
  /// Installation typically includes:
  /// - reading the downloaded ZIP file from disk
  /// - extracting USFX + metadata
  /// - parsing XML into models
  /// - writing content to SQLite (usually in a transaction)
  /// - cleanup of temporary artifacts
  ///
  /// Returns a [Stream] of [InstallProgress] describing the installation
  /// lifecycle (installing, writing to DB, done, failed).
  ///
  /// Errors are surfaced through the stream error channel as an [AppException]
  /// subtype (e.g. InstallFileMissingException, InstallParseException,
  /// InstallDatabaseException).
  Stream<InstallProgress> installBible(String bibleId);

  /// Uninstalls an installed bible from the local store.
  ///
  /// This should remove the bible metadata and all related content rows.
  ///
  /// Throws an [AppException] subtype if the operation fails.
  /// Common cases:
  /// - [UninstallNotFoundException] if the bible is not installed
  /// - [UninstallationException] for unexpected database failures
  Future<void> uninstallBible(String bibleId);

  /// Returns the list of bibles currently installed in the local store.
  ///
  /// This is a one-shot read (no live updates).
  ///
  /// Throws an [AppException] subtype (e.g. [LocalDataException]) if the
  /// query fails.
  Future<List<BibleMeta>> getInstalledBibles();

  /// Retrieves bible metadata for a specific installed bible by its local id.
  ///
  /// Throws:
  /// - [NotFoundException] if the bible id does not exist
  /// - [LocalDataException] for database/query failures
  Future<BibleMeta> getBible(int bibleId);

  /// Watches the list of installed bibles and emits updates whenever the
  /// underlying local store changes.
  ///
  /// Errors are surfaced via the stream error channel as an [AppException]
  /// subtype (typically [LocalDataException]).
  Stream<List<BibleMeta>> watchInstalledBibles();

  /// Loads a single verse (as one or more segments depending on your model).
  ///
  /// Throws:
  /// - [NotFoundException] if the verse does not exist
  /// - [LocalDataException] for database/query failures
  Future<VerseSegment> getVerse(
      int bibleId, String book, int chapter, int verse);

  /// Loads a list of verses within a range.
  ///
  /// Throws:
  /// - [NotFoundException] if the range yields no verses
  /// - [LocalDataException] for database/query failures
  Future<List<VerseSegment>> getVerseFromRange(
      int bibleId, String bookId, int chapter, int verse);

  /// Loads all verse segments for a chapter (text only, no spans
  /// e.g. no formatting)
  ///
  /// Throws:
  /// - [NotFoundException] if the chapter has no content
  /// - [LocalDataException] for database/query failures
  Future<List<VerseSegment>> getChapter(
      int bibleId, String bookId, int chapter);

  /// Loads all verse segments for a chapter, including formatting spans.
  ///
  /// Throws:
  /// - [NotFoundException] if the chapter has no content
  /// - [LocalDataException] for database/query failures
  Future<List<VerseSegment>> getChapterWithSpans(
      int bibleId, String bookId, int chapter);

  /// Loads the list of books available for a given installed bible.
  ///
  ///
  /// Throws:
  /// - [NotFoundException] if the bible has no books / is not installed
  /// - [LocalDataException] for database/query failures
  Future<List<Book>> getBooks(int bibleId);

  /// Search a string within the given bible
  /// and returns a List of bible references
  ///
  /// Throws:
  /// - [NotFoundException] if the range yields no verses
  /// - [LocalDataException] for database/query failures
  Future<List<BibleRef>> searchVerses(int bibleId, String matchingString);

  /// Get verse segments from a List of bible references
  ///
  /// Throws:
  /// - [NotFoundException] if the range yields no verses
  /// - [LocalDataException] for database/query failures
  Future<List<VerseSegment>> getVersesSegments(
      int bibleId, List<BibleRef> refs);

  Future<int> getMaxChapter(int bookId);
  Future<int> getMaxVerseRange(int bookId, int chapter);
  Future<int> resolveBookNameToId(int bibleId, String extId);
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
            usfxId: r.usfxId,
            bibleName: r.bibleName,
            abbreviation: r.bibleNameAbbreviation,
            langEngName: r.langEngName,
            langIsoCode: r.langIsoCode,
            langNativeName: r.langNativeName,
            bibleNameLocal: r.bibleNameLocal))
        .toList();
  }

  @override
  Stream<List<BibleMeta>> watchInstalledBibles() {
    throw UnimplementedError();
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
      final appSupDir = await getTemporaryDirectory();
      final dir = Directory(p.join(appSupDir.path, bibleId));
      zipFile = File(p.join(dir.path, '$bibleId.zip')); // <-- prefer .zip

      if (!await zipFile.exists()) {
        throw InstallFileMissingException(
          'Downloaded archive not found at ${zipFile.path}',
        );
      }

      yield const InstallProgress(
        stage: InstallStage.installing,
        received: 1,
        total: 5,
        message: 'Reading downloaded file...',
      );

      late final List<int> zipBytes;
      try {
        zipBytes = await zipFile.readAsBytes();
      } catch (e, st) {
        throw InstallFileMissingException(
          'Failed to read archive bytes',
          cause: e,
          stackTrace: st,
        );
      }

      // 2) Decode zip
      yield const InstallProgress(
        stage: InstallStage.installing,
        received: 2,
        total: 5,
        message: 'Opening archive...',
      );

      late final Archive archive;
      try {
        archive = ZipDecoder().decodeBytes(zipBytes);
      } catch (e, st) {
        throw InstallZipDecodeException(
          'Failed to decode ZIP archive',
          cause: e,
          stackTrace: st,
        );
      }

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

      if (bibleContent == null || bibleContent.trim().isEmpty) {
        throw InstallArchiveContentException(
          'Missing metadata XML in archive (expected *metadata.xml)',
        );
      }
      if (metadataContent == null || metadataContent.trim().isEmpty) {
        throw InstallArchiveContentException(
          'Missing metadata XML in archive (expected *metadata.xml)',
        );
      }

      // 3) Parse
      yield const InstallProgress(
        stage: InstallStage.installing,
        received: 3,
        total: 5,
        message: 'Parsing bible content...',
      );

      late final BibleMeta bible;
      late final List<Book> books;
      late final (List<VerseSegment>, List<VerseSpanModel>) verseWithSpans;

      try {
        final usfxParser = UsfxParser(bibleContent, metadataContent);
        bible = usfxParser.getBible();
        books = usfxParser.getBooks();
        verseWithSpans = usfxParser.getVersesWithSpans();
      } catch (e, st) {
        throw InstallParseException(
          'Failed to parse USFX/metadata into models',
          cause: e,
          stackTrace: st,
        );
      }

      // 4) Insert into DB (placeholder)
      yield const InstallProgress(
        stage: InstallStage.installing,
        received: 4,
        total: 5,
        message: 'Writing to database...',
      );

      try {
        await db.insertBible(
          bible,
          books,
          verseWithSpans.$1,
          verseWithSpans.$2,
        );
      } catch (e, st) {
        throw InstallDatabaseException(
          'Failed inserting bible into database',
          cause: e,
          stackTrace: st,
        );
      }

      // 5) Cleanup
      yield const InstallProgress(
        stage: InstallStage.installing,
        received: 5,
        total: 5,
        message: 'Cleaning up...',
      );

      try {
        await zipFile.delete();
      } catch (e, st) {
        // Not fatal for correctness, but good to track
        throw InstallCleanupException(
          'Install succeeded but cleanup failed (could not delete ZIP)',
          cause: e,
          stackTrace: st,
        );
      }

      yield const InstallProgress(
        stage: InstallStage.done,
        received: 1,
        total: 1,
        message: 'Installed',
      );
    } on AppException catch (e) {
      // Emit failed progress with message + then end stream.
      yield InstallProgress(
        stage: InstallStage.failed,
        received: 0,
        total: 0,
        message: e.message,
      );

      // throw e;

      return;
    } catch (e) {
      // Truly unexpected
      yield const InstallProgress(
        stage: InstallStage.failed,
        received: 0,
        total: 0,
        message: 'Installation failed (unexpected error)',
      );
      return;
    }
  }

  @override
  Future<void> uninstallBible(String bibleId) async {
    try {
      final deleted = await (db.delete(db.bibles)
            ..where((b) => b.usfxId.equals(bibleId)))
          .go();

      if (deleted == 0) {
        throw UninstallNotFoundException('Bible not found: $bibleId');
      }
    } catch (e, st) {
      if (e is UninstallNotFoundException) rethrow;

      throw UninstallationException(
        'Failed to uninstall bible: $bibleId',
        cause: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<List<Book>> getBooks(int bibleId) async {
    try {
      final result = await db.getBooks(bibleId).get();

      print('books found: ${result.length}');

      return result
          .map((r) => Book(
                id: r.id,
                usfxId: r.usfxId,
                longName: r.longName!,
                shortName: r.shortName,
              ))
          .toList();
    } catch (e) {
      throw Error();
    }
  }

  @override
  Future<List<VerseSegment>> getChapter(
      int bibleId, String bookId, int chapter) async {
    try {
      final rows =
          await db.getVerseSegmentsForChapter(bibleId, bookId, chapter).get();

      if (rows.isEmpty) {
        throw NotFoundException(
          'No verses for $bookId $chapter (bibleId =$bibleId)',
        );
      }

      return rows
          .map((r) => VerseSegment(
                bibleId: bibleId,
                ref: BibleRef(
                  bookUsfxId: bookId,
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
    } on AppException {
      rethrow;
    } catch (e, st) {
      // Wrap *unexpected* DB/Drift errors
      throw LocalDataException(
        'Failed to load chapter $bookId $chapter (bibleId=$bibleId)',
        cause: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<List<VerseSegment>> getChapterWithSpans(
      int bibleId, String bookId, int chapter) async {
    try {
      final rows = await db
          .getSegmentsForChapterWithSpans(bibleId, bookId, chapter)
          .get();

      if (rows.isEmpty) {
        throw NotFoundException(
          'No verses for $bookId $chapter (bibleId =$bibleId)',
        );
      }

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
            bookUsfxId: bookId,
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
    } on AppException {
      rethrow;
    } catch (e, st) {
      // Wrap *unexpected* DB/Drift errors
      throw LocalDataException(
        'Failed to load chapter $bookId $chapter (bibleId=$bibleId)',
        cause: e,
        stackTrace: st,
      );
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
  Future<BibleMeta> getBible(int bibleId) async {
    try {
      final rows = await db.getBible(bibleId).get();

      if (rows.isEmpty) {
        throw NotFoundException('Bible not found (id=$bibleId)');
      }

      final r = rows.first;

      return BibleMeta(
        id: r.id,
        usfxId: r.usfxId,
        bibleName: r.bibleName,
        bibleNameLocal: r.bibleNameLocal,
        abbreviation: r.bibleNameAbbreviation,
        originSource: r.originSource,
        // language
        langEngName: r.langEngName,
        langIsoCode: r.langIsoCode,
        langNativeName: r.langNativeName,
      );
    } on AppException {
      rethrow;
    } catch (e, st) {
      // Wrap unexpected DB / Drift errors
      throw LocalDataException(
        'Failed to load bible metadata (id=$bibleId)',
        cause: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<List<BibleRef>> searchVerses(
      int bibleId, String matchingString) async {
    print('******************************');
    print('source: $bibleId');
    print('finding: $matchingString');
    final stopwatch = Stopwatch()..start();
    final rows = await db.searchVerses(bibleId, matchingString, 100).get();
    print('finished in ${stopwatch.elapsed}');
    stopwatch.stop();
    print('results count: ${rows.length}');
    print('******************************');

    if (rows.isEmpty) {
      throw NotFoundException('Match not found (id=$bibleId)');
    }

    final result = rows
        .map((r) => BibleRef(
            bookUsfxId: r.bookUsfxId,
            chapter: r.chapterNumber,
            verseStart: r.verseNumber))
        .toList();

    return result;
  }

  @override
  Future<List<VerseSegment>> getVersesSegments(
    int bibleId,
    List<BibleRef> refs,
  ) async {
    try {
      if (refs.isEmpty) return [];

      // hard cap
      final capped = refs.length > 100 ? refs.sublist(0, 100) : refs;

      final parts = <String>[];
      final vars = <Variable>[];

      for (final r in capped) {
        parts.add('(?, ?, ?)'); // osis, chapter, verse
        vars.addAll([
          Variable<String>(r.bookUsfxId),
          Variable<int>(r.chapter),
          Variable<int>(r.verseStart),
        ]);
      }

      final sql = '''
        WITH ref(bookUsfxId, chapterNumber, verseNumber) AS (
          VALUES ${parts.join(',')}
        )
        SELECT 
          s.*,
          b.usfxId AS bookusfxId
        FROM ref
        JOIN books AS b
          ON b.bibleId = ? AND b.usfxId = ref.bookusfxId
        JOIN verse_segments AS s
          ON s.bookId = b.id
          AND s.chapterNumber = ref.chapterNumber
          AND s.verseNumber = ref.verseNumber
        ORDER BY b.bookOrder, s.chapterNumber, s.verseNumber, s.segmentIndex
      ''';

      // prepend bibleId var at the right position
      final allVars = <Variable>[...vars, Variable<int>(bibleId)];

      final rows = await db.customSelect(
        sql,
        variables: allVars,
        readsFrom: {db.verseSegments, db.books},
      ).get();

      return rows.map((r) {
        final bookusfxId = r.read<String>('bookusfxId');
        final chapterNumber = r.read<int>('chapterNumber');
        final verseNumber = r.read<int>('verseNumber');

        return VerseSegment(
          bibleId: bibleId,
          ref: BibleRef(
            bookUsfxId: bookusfxId,
            chapter: chapterNumber,
            verseStart: verseNumber,
          ),
          segmentIndex: r.read<int>('segmentIndex'),
          paragraphStart: r.read<int>('paragraphStart') == 1,
          textContent: r.read<String>('textContent'),
          subtitle: r.readNullable<String>('subtitle'),
          spans: const [],
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<int> getMaxChapter(int bookId) async {
    try {
      final result = await db.getMaxChapter(bookId).get();
      return result.first ?? 0;
    } catch (e) {
      throw Error();
    }
  }

  @override
  Future<int> getMaxVerseRange(int bookId, int chapter) async {
    try {
      final result = await db.getMaxVerse(bookId, chapter).get();
      return result.first ?? 0;
    } catch (e) {
      throw Error();
    }
  }

  @override
  Future<int> resolveBookNameToId(int bibleId, String extId) async {
    try {
      final r = await db.resolveBookNameToId(bibleId, extId).get();

      if (r.isEmpty) {
        throw NotFoundException('Not resolvable book name: $bibleId, $extId');
      }

      return r.first;
    } catch (e) {
      throw Error();
    }
  }
}
