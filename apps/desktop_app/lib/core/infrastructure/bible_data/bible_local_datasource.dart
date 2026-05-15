import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:open_scripture/core/systems/installer/bible/domain/models/artifact.dart';
import 'package:open_scripture/shared/data/models/verse_span_model.dart';
import 'package:open_scripture/shared/entities/book.dart';
import 'package:open_scripture/core/infrastructure/database/installation_queries.dart';
import 'package:open_scripture/shared/entities/bible_ref.dart';
import 'package:open_scripture/features/bible_installer_manager/domain/entities/bible_download_progress.dart';

import '../../../shared/entities/bible_meta.dart';
import '../database/database.dart' as driftdb;
import '../../../shared/error/exception.dart';
import '../../../shared/entities/verse_segment.dart';
import '../../systems/installer/bible/import/importer_registry.dart';
import '../../systems/installer/bible/source/packages/source_package_factory.dart';

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
  Stream<InstallProgress> installBible(Artifact artifact);

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

  /// Search a string within the given bibles
  /// and returns a List of bible references
  ///
  /// Throws:
  /// - [NotFoundException] if the range yields no verses
  /// - [LocalDataException] for database/query failures
  Future<List<BibleRef>> searchVerses(
      List<int> bibleIds, String matchingString);

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
  final SourcePackageFactory sourcePackageFactory;
  final ImporterRegistry importerRegistry;

  BibleLocalDatasourceImpl({
    required this.db,
    required this.importerRegistry,
    required this.sourcePackageFactory,
  });

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
              bibleNameLocal: r.bibleNameLocal,
              abbreviation: r.bibleNameAbbreviation,
              originSource: r.originSource,
              originFormat: r.originFormat,
              description: r.description,
              copyright: r.copyright,
              langEngName: r.langEngName,
              langIsoCode: r.langIsoCode,
              langNativeName: r.langNativeName,
            ))
        .toList();
  }

  @override
  Stream<List<BibleMeta>> watchInstalledBibles() {
    throw UnimplementedError();
  }

  @override
  Stream<InstallProgress> installBible(Artifact artifact) async* {
    try {
      yield const InstallProgress(
        stage: InstallStage.installing,
        message: 'Preparing source...',
      );
      final pkg = await sourcePackageFactory.fromPath(artifact.path);

      yield const InstallProgress(
        stage: InstallStage.installing,
        message: 'Detecting format...',
      );
      final importer = await importerRegistry.resolve(pkg);

      yield InstallProgress(
        stage: InstallStage.installing,
        message: 'Parsing ${importer.formatId}...',
      );
      final canonical = await importer.importFrom(pkg);

      if (canonical.hasErrors) {
        yield InstallProgress(
          stage: InstallStage.failed,
          message: 'Import produced errors',
        );
        return;
      }

      yield const InstallProgress(
        stage: InstallStage.installing,
        message: 'Writing to database...',
      );
      try {
        await db.insertBible(
          canonical.data.bibleMeta,
          canonical.data.books,
          canonical.data.segments,
          canonical.data.spans,
        );
      } catch (e, st) {
        throw InstallDatabaseException(
          'Failed inserting bible into database',
          cause: e,
          stackTrace: st,
        );
      }

      yield const InstallProgress(
        stage: InstallStage.done,
        message: 'Installed',
      );
    } on InstallDatabaseException catch (e) {
      yield InstallProgress(
        stage: InstallStage.failed,
        received: 0,
        total: 0,
        message: e.message,
      );
    } catch (e) {
      yield const InstallProgress(
        stage: InstallStage.failed,
        received: 0,
        total: 0,
        message: 'Installation failed (unexpected error)',
      );
    }
  }

  @override
  Future<void> uninstallBible(String bibleId) async {
    try {
      final deleted = await (db.delete(db.bibles)
            ..where((b) => b.extId.equals(bibleId)))
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
        extId: r.extId,
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
      List<int> bibleIds, String matchingString) async {
    // TODO: support multiple bibleIds
    final bibleId =
        bibleIds.first; // temp, for making the errors disappear and compile
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
