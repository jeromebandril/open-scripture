import 'package:open_scripture/shared/data/datasources/bible_content_datasource/bible_content_datasourcee.dart';
import 'package:open_scripture/shared/data/models/verse_segment_dto.dart';

class SwordBibleContentDatasourceImpl implements BibleContentDatasource {
  @override
  Future<int> getChapterBoundaryOf({required String bookToken}) {
    // TODO: implement getChapterBoundaryOf
    throw UnimplementedError();
  }

  @override
  Future<List<VerseSegmentDto>> getChapterWithSpans(
      String bibleExtId, String bookToken, int chapter) {
    // TODO: implement getChapterWithSpans
    throw UnimplementedError();
  }

  @override
  Future<int> getVerseBoundaryOf(
      {required String bookToken, required int chapter}) {
    // TODO: implement getVerseBoundaryOf
    throw UnimplementedError();
  }

  @override
  Future<List<String>> searchVerses(List<int> bibleIds, String matchingString) {
    // TODO: implement searchVerses
    throw UnimplementedError();
  }
}
