import 'package:open_scripture/shared/data/models/verse_segment_dto.dart';

abstract class BibleContentDatasource {
  Future<List<VerseSegmentDto>> getChapterWithSpans(
    String bibleExtId,
    String bookToken,
    int chapter,
  );

  Future<List<String>> searchVerses(List<int> bibleIds, String matchingString);

  // these are new additions
  Future<int> getVerseBoundaryOf({
    required String bookToken,
    required int chapter,
  });
  Future<int> getChapterBoundaryOf({required String bookToken});
}
