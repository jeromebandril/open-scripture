import 'package:open_scripture/core/infrastructure/database/daos/bible_content_dao.dart';
import 'package:open_scripture/shared/data/datasources/bible_content_datasource/bible_content_datasourcee.dart';
import 'package:open_scripture/shared/data/models/verse_segment_dto.dart';

class DriftBibleContentDataSourceImpl implements BibleContentDatasource {
  final BibleContentDao _dao;

  DriftBibleContentDataSourceImpl({required BibleContentDao dao}) : _dao = dao;

  @override
  Future<List<VerseSegmentDto>> getChapterWithSpans(
    String bibleExtId,
    String bookToken,
    int chapter,
  ) async {
    return _dao.getChapter(bibleExtId, bookToken, chapter);
  }

  @override
  Future<List<String>> searchVerses(List<int> bibleIds, String matchingString) {
    return _dao.searchVerses(bibleIds, matchingString);
  }

  @override
  Future<int> getVerseBoundaryOf({
    required String bookToken,
    required int chapter,
  }) {
    return _dao.getVerseBoundaryOf(bookToken: bookToken, chapter: chapter);
  }

  @override
  Future<int> getChapterBoundaryOf({required String bookToken}) {
    return _dao.getChapterBoundaryOf(bookToken: bookToken);
  }
}
