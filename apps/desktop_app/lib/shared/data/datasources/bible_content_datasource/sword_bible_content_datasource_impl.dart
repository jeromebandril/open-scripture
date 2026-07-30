import 'dart:convert';

import '../../../domain/entities/bible_book.dart';
import '../../../domain/entities/bible_ref.dart';
import '../../../error/exception.dart';
import '../../models/verse_segment_dto.dart';
import '../../services/sword_service.dart';
import 'bible_content_datasourcee.dart';

class SwordBibleContentDatasourceImpl implements BibleContentDatasource {
  final SwordService _swordService;

  const SwordBibleContentDatasourceImpl({required SwordService swordService})
      : _swordService = swordService;

  @override
  Future<int> getChapterBoundaryOf({required String bookToken}) {
    throw UnimplementedError();
  }

  @override
  Future<List<VerseSegmentDto>> getChapter(
      String bibleExtId, BibleBook book, int chapter) async {
    print('getting this: $bibleExtId - ${book.osis}:$chapter');

    final bridge = await _swordService.instance;
    final rawJson = bridge.getChapter(bibleExtId, book.osis, chapter);

    if (rawJson.isEmpty || rawJson == '[]') {
      throw NotFoundException(
          'No verses found for $bibleExtId ${book.osis} $chapter');
    }

    try {
      final List<dynamic> parsedVerses = jsonDecode(rawJson);
      return parsedVerses.map((verseData) {
        final verseNum = verseData['verse'] as int;
        var verseText = verseData['text'] as String;
        final isParagraphStart =
            verseText.startsWith('\n') || verseText.startsWith('\r\n');
        verseText = verseText.trim();

        return VerseSegmentDto(
          bibleId: bibleExtId.hashCode,
          bookToken: book.osis,
          chapterNumber: chapter,
          verseNumber: verseNum,
          segmentIndex: 0,
          paragraphStart: isParagraphStart,
          spansJson: jsonEncode([
            {'text': verseText, 'activeStyles': []}
          ]),
        );
      }).toList();
    } catch (e) {
      throw SwordException('Malformed chapter JSON from SWORD bridge: $e');
    }
  }

  @override
  Future<Map<BibleRef, List<VerseSegmentDto>>> getVerses(
      String bibleExtId, List<BibleRef> refs) {
    // TODO: implement getVerses
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
