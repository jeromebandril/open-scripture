import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:open_scripture/core/infrastructure/bible_data/content/bible_content_datasource.dart';
import 'package:open_scripture/shared/data/models/verse_span_model.dart';
import 'package:open_scripture/shared/entities/book.dart';
import 'package:open_scripture/shared/entities/bible_ref.dart';

import '../../database/database.dart' as driftdb;
import '../../../../shared/error/exception.dart';
import '../../../../shared/entities/verse_segment.dart';
import '../../../engines/bible_compiler/import/importer_registry.dart';
import '../../../engines/bible_compiler/source/packages/source_package_factory.dart';

class BibleContentDatasourceLocalImpl implements BibleContentDatasource {
  final driftdb.AppDb db;
  final SourcePackageFactory sourcePackageFactory;
  final ImporterRegistry importerRegistry;

  BibleContentDatasourceLocalImpl({
    required this.db,
    required this.sourcePackageFactory,
    required this.importerRegistry,
  });

  @override
  Future<List<Book>> getBooks(int bibleId) async {
    try {
      final result = await db.getBooks(bibleId).get();

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
