import '../../../../core/infrastructure/database/daos/bible_content_dao.dart';
import '../../../domain/entities/bible_book.dart';
import '../../models/verse_segment_dto.dart';
import 'bible_content_datasourcee.dart';

class DriftBibleContentDataSourceImpl implements BibleContentDatasource {
  final BibleContentDao _dao;

  DriftBibleContentDataSourceImpl({required BibleContentDao dao}) : _dao = dao;

  @override
  Future<List<VerseSegmentDto>> getChapterWithSpans(
    String bibleExtId,
    BibleBook book,
    int chapter,
  ) async {
    return _dao.getChapter(bibleExtId, book.usfm, chapter);
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
