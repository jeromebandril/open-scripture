import '../../../domain/entities/bible_book.dart';
import '../../../domain/entities/bible_ref.dart';
import '../../models/verse_segment_dto.dart';

abstract class BibleContentDatasource {
  /// Throws [NotFoundException] if no verses exist for [book]/[chapter] in [bibleExtId].
  Future<List<VerseSegmentDto>> getChapter(
    String bibleExtId,
    BibleBook book,
    int chapter,
  );

  Future<Map<BibleRef, List<VerseSegmentDto>>> getVerses(
    String bibleExtId,
    List<BibleRef> refs,
  );

  Future<List<String>> searchVerses(List<int> bibleIds, String matchingString);

  Future<int> getVerseBoundaryOf({
    required String bookToken,
    required int chapter,
  });

  Future<int> getChapterBoundaryOf({required String bookToken});
}
