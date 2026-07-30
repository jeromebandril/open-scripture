import '../../../../core/infrastructure/database/daos/bible_content_dao.dart';
import '../../../domain/entities/bible_book.dart';
import '../../../domain/entities/bible_ref.dart';
import '../../../error/exception.dart';
import '../../models/verse_segment_dto.dart';
import 'bible_content_datasourcee.dart';

class DriftBibleContentDataSourceImpl implements BibleContentDatasource {
  final BibleContentDao _dao;

  DriftBibleContentDataSourceImpl({required BibleContentDao dao}) : _dao = dao;

  @override
  Future<List<VerseSegmentDto>> getChapter(
    String bibleExtId,
    BibleBook book,
    int chapter,
  ) async {
    final List<VerseSegmentDto> result;
    try {
      result = await _dao.getChapter(bibleExtId, book.usfm, chapter);
    } catch (e) {
      throw Exception('Failed to query chapter: $e');
    }

    if (result.isEmpty) {
      throw NotFoundException('No verses found for ${book.usfm} $chapter');
    }
    return result;
  }

  @override
  Future<Map<BibleRef, List<VerseSegmentDto>>> getVerses(
    String bibleExtId,
    List<BibleRef> refs,
  ) async {
    final Map<BibleRef, List<VerseSegmentDto>> results;

    try {
      final fetchFutures = refs.map((ref) async {
        final dto = await _dao.getVerse(
          bibleExtId,
          ref.book.canonical,
          ref.chapter,
          ref.verseStart!,
        );
        return MapEntry(ref, dto);
      });

      final entries = await Future.wait(fetchFutures);

      results = {
        for (final entry in entries)
          if (entry.value != null) entry.key: [entry.value!],
      };
    } catch (e) {
      throw Exception('Failed to query chapter: $e');
    }

    if (results.isEmpty) {
      throw NotFoundException('No verses found');
    }
    return results;
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
