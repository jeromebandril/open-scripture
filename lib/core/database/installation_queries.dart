import 'package:drift/drift.dart';
import 'package:open_scripture/core/domain/entities/book_names.dart';
import 'package:open_scripture/core/data/models/segment_key.dart';
import 'package:open_scripture/core/data/models/verse_span_model.dart';
import 'package:open_scripture/core/domain/entities/verse_segment.dart';

import '../../injection_container.dart';
import '../domain/entities/bible_meta.dart';
import '../domain/entities/book.dart';
import 'database.dart' as db;

extension BibleInstallQueries on db.AppDb {
  Future<int> _getOrCreateLanguageId({
    required String langEngName,
    String? langNativeName,
    String? langIsoCode,
  }) async {
    await into(languages).insert(
      db.LanguagesCompanion.insert(
        langEngName: langEngName,
        langNativeName: Value(langNativeName),
        langIsoCode: Value(langIsoCode),
      ),
      mode: InsertMode.insertOrIgnore,
    );

    // Pick a stable lookup key. Prefer ISO code if present.
    if (langIsoCode != null && langIsoCode.isNotEmpty) {
      final row = await (select(languages)
            ..where((t) => t.langIsoCode.equals(langIsoCode)))
          .getSingle();
      return row.id;
    } else {
      final row = await (select(languages)
            ..where((t) => t.langEngName.equals(langEngName)))
          .getSingle();
      return row.id;
    }
  }

  Future<int> insertBible(
    BibleMeta meta,
    List<Book> bookList,
    List<VerseSegment> verseSegments,
    List<VerseSpanModel> verseSpans,
  ) async {
    return transaction(() async {
      // 1) Insert language + bible metadata, get bibleId
      final bibleId = await insertBibleMetadataOnly(meta);

      // 2) Insert books
      await insertBooksOnly(bibleId, bookList);
      final bookMap = await _getBookIdMap(bibleId);

      // 3) Insert verse segments with spans
      await insertVerseSegmentsWithSpans(
          verseSegments, verseSpans, bookMap, bibleId);

      return bibleId;
    });
  }

  Future<int> insertBibleMetadataOnly(BibleMeta meta) async {
    return await transaction(() async {
      int? languageId;

      // Optional: only link language if you actually have language info
      if ((meta.langEngName ?? '').isNotEmpty ||
          (meta.langIsoCode ?? '').isNotEmpty) {
        final eng = (meta.langEngName?.isNotEmpty ?? false)
            ? meta.langEngName!
            : 'Unknown';

        languageId = await _getOrCreateLanguageId(
          langEngName: eng,
          langNativeName: meta.langNativeName,
          langIsoCode: meta.langIsoCode,
        );
      }

      return await into(bibles).insert(
        db.BiblesCompanion.insert(
          usfxId: meta.usfxId,
          languageId: Value(languageId), // nullable
          bibleName: meta.bibleName,
          bibleNameLocal: meta.bibleNameLocal,
          bibleNameAbbreviation: meta.abbreviation,
          originSource: Value(meta.originSource),
        ),
        mode: InsertMode.insertOrIgnore,
      );
    });
  }

  Future<void> insertBooksOnly(int bibleId, List<Book> bookList) async {
    final resolver = sl<BibleRefResolver>();

    await batch((b) {
      b.insertAll(
        books,
        [
          for (var i = 0; i < bookList.length; i++)
            db.BooksCompanion.insert(
              bibleId: bibleId,
              usfxId: bookList[i].usfxId!,
              osisId: resolver.resolveBook(bookList[i].usfxId!)!.osisId,
              shortName: bookList[i].shortName,
              longName: Value(bookList[i].longName),
            )
        ],
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<Map<String, int>> _getBookIdMap(int bibleId) async {
    final rows =
        await (select(books)..where((b) => b.bibleId.equals(bibleId))).get();

    final map = <String, int>{};
    for (final r in rows) {
      final usfxId = r.usfxId;
      if (usfxId == null || usfxId.isEmpty) continue;
      map[usfxId] = r.id;
    }
    return map;
  }

  Future<void> insertVerseSegmentsOnly(
      List<VerseSegment> verses, Map<String, int> bookMap) async {
    await batch((b) {
      b.insertAll(
        verseSegments,
        [
          for (var i = 0; i < verses.length; i++)
            db.VerseSegmentsCompanion.insert(
              bookId: bookMap[verses[i].ref.bookUsfxId]!,
              chapterNumber: verses[i].ref.chapter,
              verseNumber: verses[i].ref.verseStart!,
              segmentIndex: verses[i].segmentIndex,
              textContent: verses[i].textContent,
            )
        ],
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<void> insertVerseSegmentsWithSpans(
    List<VerseSegment> segments,
    List<VerseSpanModel> spans,
    Map<String, int> bookMap,
    int bibleId,
  ) async {
    await transaction(() async {
      await insertVerseSegmentsOnly(segments, bookMap);

      // Insert verse text for fts5 search
      await populateVerseText(bibleId);

      // Insert verse segments
      final rows = await getSegmentsByBibleId(bibleId).get();

      // Build a map of segments id
      final Map<SegmentKey, int> segmentIdByKey = {};
      for (final row in rows) {
        final key = SegmentKey(
          bookUsfxId: row.bookUsfxId,
          chapter: row.chapterNumber,
          verse: row.verseNumber,
          segmentIndex: row.segmentIndex,
        );

        final segmentId = row.id;

        segmentIdByKey[key] = segmentId;
      }
      if (segmentIdByKey.length != rows.length) {
        throw StateError('Duplicate SegmentKey detected');
      }

      // Build spans companions
      final spansCompanions = <db.SegmentSpansCompanion>[];
      for (final s in spans) {
        // at this point the segment key should be not null
        if (s.key == null) {
          throw StateError('Span has no segment_key during import');
        }

        final key = SegmentKey(
          bookUsfxId: s.key!.bookUsfxId,
          chapter: s.key!.chapter,
          verse: s.key!.verse,
          segmentIndex: s.key!.segmentIndex,
        );

        final segmentId = segmentIdByKey[key];
        if (segmentId == null) {
          throw StateError('Missing segmentId for $key (span $s)');
        }

        spansCompanions.add(
          db.SegmentSpansCompanion.insert(
            segmentId: segmentId,
            startOffset: s.startOffset,
            endOffset: s.endOffset,
            spanType: s.type.index,
            payload: Value(s.payload),
          ),
        );
      }

      // Insert spans in chunks
      const chunkSize = 10000;
      for (var i = 0; i < spans.length; i += chunkSize) {
        final chunk = spansCompanions.sublist(
            i, (i + chunkSize).clamp(0, spansCompanions.length));

        await batch((b) {
          b.insertAll(segmentSpans, chunk);
        });
      }
    });
  }
}
