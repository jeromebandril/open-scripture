import 'package:drift/drift.dart';

import '../../../../shared/data/models/verse_segment_dto.dart';
import '../database.dart';

part 'bible_content_dao.g.dart';

@DriftAccessor(tables: [VerseSegments, CanonicalBooks])
class BibleContentDao extends DatabaseAccessor<AppDb>
    with _$BibleContentDaoMixin {
  BibleContentDao(super.db);

  /// Retrieves an entire chapter, ordered correctly for the UI.
  Future<List<VerseSegmentDto>> getChapter(
    String bibleExtId,
    String bookToken,
    int chapter,
  ) async {
    // get bible id
    final bibleId = await (select(db.bibles)
          ..addColumns([db.bibles.id])
          ..where((tbl) => tbl.extId.equals(bibleExtId)))
        .map((row) => row.id)
        .getSingleOrNull();

    if (bibleId == null) return const [];

    final query = select(db.verseSegments).join([
      innerJoin(
        db.canonicalBooks,
        db.canonicalBooks.id.equalsExp(db.verseSegments.bookId),
      ),
    ])
      ..where(db.verseSegments.bibleId.equals(bibleId) &
          db.canonicalBooks.bookToken.equals(bookToken) &
          db.verseSegments.chapterNumber.equals(chapter))
      ..orderBy([
        OrderingTerm.asc(db.verseSegments.verseNumber),
        OrderingTerm.asc(db.verseSegments.segmentIndex),
      ]);

    final results = await query.get();
    return results.map((row) {
      final segment = row.readTable(db.verseSegments);
      final book = row.readTable(db.canonicalBooks);

      return VerseSegmentDto(
        bibleId: segment.bibleId,
        bookToken: book.bookToken,
        chapterNumber: segment.chapterNumber,
        verseNumber: segment.verseNumber,
        segmentIndex: segment.segmentIndex,
        paragraphStart: segment.paragraphStart == 1,
        heading: segment.heading,
        spansJson: segment.spansJson,
      );
    }).toList();
  }

  /// TODO: implement search/find
  Future<List<String>> searchVerses(List<int> bibleIds, String queryStr) async {
    // Implementation for FTS (Full Text Search) or LIKE matching goes here...
    return [];
  }

  /// Returns the highest verse number in a given chapter
  Future<int> getVerseBoundaryOf({
    required String bookToken,
    required int chapter,
  }) async {
    final maxVerse = db.verseSegments.verseNumber.max();
    final query = selectOnly(db.verseSegments).join([
      innerJoin(
        db.canonicalBooks,
        db.canonicalBooks.id.equalsExp(db.verseSegments.bookId),
      ),
    ])
      ..addColumns([maxVerse])
      ..where(db.canonicalBooks.bookToken.equals(bookToken) &
          db.verseSegments.chapterNumber.equals(chapter));

    final result = await query.getSingle();
    return result.read(maxVerse) ?? 0;
  }

  /// Returns the highest chapter number in a given book
  Future<int> getChapterBoundaryOf({required String bookToken}) async {
    final maxChapter = db.verseSegments.chapterNumber.max();
    final query = selectOnly(db.verseSegments).join([
      innerJoin(
        db.canonicalBooks,
        db.canonicalBooks.id.equalsExp(db.verseSegments.bookId),
      ),
    ])
      ..addColumns([maxChapter])
      ..where(db.canonicalBooks.bookToken.equals(bookToken));

    final result = await query.getSingle();
    return result.read(maxChapter) ?? 0;
  }
}
