import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../shared/data/models/bible_install_dto.dart';
import '../database.dart';

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
    // language info is not important
    required String? langIsoCode,
    required String? langEnglishName,
    required String? langNativeName,
    required TranslationInstallDto translation,
    required List<BookInstallDto> books,
    required List<VerseSegmentInstallDto> segments,
  }) async {
    return transaction(() async {
      // 1. Resolve or Insert Language first to guarantee a valid languageId
      final languageId = await db.languagesDao.getOrCreateLanguageId(
        code: langIsoCode,
        engName: langEnglishName,
        nativeName: langNativeName,
      );

      // 2. Map & Insert the Bible Row using the newly resolved languageId
      final bibleId = await into(db.bibles).insert(
        BiblesCompanion.insert(
          extId: translation.extId,
          bName: translation.name,
          nameLocal: Value(translation.localName),
          abbreviation: translation.abbreviation,
          bDescription: Value(translation.description),
          languageId: Value(languageId),
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

  Future<Map<String, int>> getCanonicalBookMap() async {
    final rows = await select(db.canonicalBooks).get();
    return {for (final row in rows) row.bookToken: row.id};
  }
}
