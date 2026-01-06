import 'package:drift/drift.dart';
import 'package:the_smyrna_bible_v2/core/domain/entities/verse_segment.dart';
import 'package:the_smyrna_bible_v2/core/domain/entities/verse_span.dart';

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

  Future<int> insertBible(meta, bookList, verseSegments) async {
    return transaction(() async {
      // 1) Insert language + bible metadata, get bibleId
      final bibleId = await insertBibleMetadataOnly(meta);

      // 2) Insert books
      await insertBooksOnly(bibleId, bookList);
      final bookMap = await _getBookIdMap(bibleId);

      // 3) Insert verses segments/spans
      await insertVerseSegmentsOnly(verseSegments, bookMap);

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
          extId: meta.extId,
          languageId: Value(languageId), // nullable
          bibleName: meta.bibleName,
          bibleNameAbbreviation: meta.abbreviation,
          originSource: Value(meta.originSource),
        ),
        mode: InsertMode.insertOrIgnore, // ✅ idempotent install
      );
    });
  }

  Future<void> insertBooksOnly(int bibleId, List<Book> bookList) async {
    await batch((b) {
      b.insertAll(
        books,
        [
          for (var i = 0; i < bookList.length; i++)
            db.BooksCompanion.insert(
              bibleId: bibleId,
              osisId: bookList[i].osisId!,
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
      final osis = r.osisId;
      if (osis == null || osis.isEmpty) continue;
      map[osis] = r.id;
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
              bookId: bookMap[verses[i].ref.bookOsisId]!,
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
}
