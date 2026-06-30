import 'dart:convert';

import '../../../../core/sword/sword_bridge.dart';
import '../../../domain/entities/bible_book.dart';
import '../../models/verse_segment_dto.dart';
import 'bible_content_datasourcee.dart';

class SwordBibleContentDatasourceImpl implements BibleContentDatasource {
  final SwordBridge _swordBridge;

  const SwordBibleContentDatasourceImpl({required SwordBridge swordBridge})
      : _swordBridge = swordBridge;

  @override
  Future<int> getChapterBoundaryOf({required String bookToken}) {
    // TODO: implement getChapterBoundaryOf
    throw UnimplementedError();
  }

  @override
  Future<List<VerseSegmentDto>> getChapterWithSpans(
      String bibleExtId, BibleBook book, int chapter) {
    print('getting this: $bibleExtId - ${book.osis}:$chapter');

    final rawJson = _swordBridge.getChapter(bibleExtId, book.osis, chapter);

    if (rawJson.isEmpty || rawJson == "[]") {
      return Future.value([]);
    }

    try {
      final List<dynamic> parsedVerses = jsonDecode(rawJson);
      final List<VerseSegmentDto> segments = [];

      for (final verseData in parsedVerses) {
        final int verseNum = verseData['verse'] as int;
        String verseText = verseData['text'] as String;
        bool isParagraphStart =
            verseText.startsWith('\n') || verseText.startsWith('\r\n');
        verseText = verseText.trim();

        final String encodedSpans = jsonEncode([
          {"text": verseText, "activeStyles": []}
        ]);

        segments.add(
          VerseSegmentDto(
            bibleId: bibleExtId.hashCode,
            bookToken: book.osis,
            chapterNumber: chapter,
            verseNumber: verseNum,
            segmentIndex: 0,
            paragraphStart: isParagraphStart,
            spansJson: encodedSpans,
          ),
        );
      }

      return Future.value(segments);
    } catch (e) {
      print('Error parsing chapter JSON from SWORD bridge: $e');
      return Future.value([]);
    }
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
