import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:open_scripture/core/infrastructure/database/database.dart';
import 'package:open_scripture/shared/data/models/bible_install_dto.dart';

part 'bible_installation_dao.g.dart';

@DriftAccessor(tables: [
  Languages,
  Bibles,
  CanonicalBooks,
  LocalizedBookNames,
  VerseSegments
])
class BibleInstallationDao extends DatabaseAccessor<AppDb>
    with _$BibleInstallationDaoMixin {
  BibleInstallationDao(super.db);

  Future<int> executeInstallation({
    required String languageEnglishName,
    required String languageIsoCode,
    required String? languageNativeName,
    required TranslationInstallDto translation,
    required List<BookInstallDto> books,
    required List<VerseSegmentInstallDto> segments,
  }) async {
    return transaction(() async {
      // 1. Resolve or Insert Language first to guarantee a valid languageId
      final languageId = await _getOrCreateLanguageId(
        engName: languageEnglishName,
        isoCode: languageIsoCode,
        nativeName: languageNativeName,
      );

      // 2. Map & Insert the Bible Row using the newly resolved languageId
      final bibleId = await into(db.bibles).insert(
        BiblesCompanion.insert(
          extId: translation.extId,
          bName: translation.name,
          nameLocal: Value(translation.localName),
          abbreviation: translation.abbreviation,
          bDescription: Value(translation.description),
          languageId: languageId,
          copyright: Value(translation.copyright),
          originFormat: Value(translation.originFormat),
          originSource: Value(translation.originSource),
        ),
        mode: InsertMode.insertOrReplace,
      );

      // 3. Fetch the lookup Map for Canonical Books
      final canonicalIdMap = await getCanonicalBookMap();

      // 4. Map & Batch Insert Localized Books
      final booksToInsert = books.map((b) {
        final dbId = canonicalIdMap[b.book.canonical];
        if (dbId == null) {
          throw StateError(
              'Canonical DB row missing for book: ${b.book.canonical}');
        }
        return LocalizedBookNamesCompanion.insert(
          bookId: dbId,
          longName: b.longName,
          shortName: b.shortName,
          bibleId: bibleId,
        );
      }).toList();

      await batch((b) => b.insertAll(db.localizedBookNames, booksToInsert,
          mode: InsertMode.insertOrReplace));

      // 5. Map & Batch Insert Verse Segments
      final segmentsToInsert = segments.map((seg) {
        final dbId = canonicalIdMap[seg.book.canonical];
        if (dbId == null) {
          throw StateError(
              'Canonical DB row missing for book: ${seg.book.canonical}');
        }

        final spansJsonString = jsonEncode(seg.spans
            .map((s) => {
                  'activeStyles':
                      s.activeStyles.map((type) => type.name).toList(),
                  'text': s.text,
                  'payload': s.payload,
                })
            .toList());

        return VerseSegmentsCompanion.insert(
          bookId: dbId,
          chapterNumber: seg.chapter,
          verseNumber: seg.verse,
          segmentIndex: seg.segmentIndex,
          paragraphStart: Value(seg.isParagraphStart ? 1 : 0),
          spansJson: spansJsonString,
          bibleId: bibleId, // Injected smoothly!
        );
      }).toList();

      await batch((b) => b.insertAll(db.verseSegments, segmentsToInsert,
          mode: InsertMode.insertOrReplace));

      return bibleId;
    });
  }

  Future<void> executeUninstallation(int bibleId) async {
    await (delete(db.bibles)..where((t) => t.id.equals(bibleId))).go();
  }

  // --- Private Helpers ---

  Future<int> _getOrCreateLanguageId({
    required String engName,
    required String isoCode,
    String? nativeName,
  }) async {
    await into(db.languages).insert(
      LanguagesCompanion.insert(
        isoCode: isoCode,
        engName: engName,
        nativeName: Value(nativeName),
      ),
      mode: InsertMode.insertOrIgnore,
    );

    if (isoCode.isNotEmpty) {
      final row = await (select(db.languages)
            ..where((t) => t.isoCode.equals(isoCode)))
          .getSingle();
      return row.id;
    } else {
      final row = await (select(db.languages)
            ..where((t) => t.engName.equals(engName)))
          .getSingle();
      return row.id;
    }
  }

  Future<Map<String, int>> getCanonicalBookMap() async {
    final rows = await select(db.canonicalBooks).get();
    return {for (final row in rows) row.bookToken: row.id};
  }
}
