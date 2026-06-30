import 'dart:convert';

import '../../domain/entities/bible_book.dart';
import '../../domain/entities/verse.dart';

class VerseSegmentDto {
  final int bibleId;
  final String bookToken;
  final int chapterNumber;
  final int verseNumber;
  final int segmentIndex;
  final bool paragraphStart;
  final String? heading;
  final String? spansJson;

  VerseSegmentDto({
    required this.bibleId,
    required this.bookToken,
    required this.chapterNumber,
    required this.verseNumber,
    required this.segmentIndex,
    required this.paragraphStart,
    this.heading,
    this.spansJson,
  });

  factory VerseSegmentDto.fromGetBibleApiV2({
    required Map<String, dynamic> verseData,
    required BibleBook book,
    required bibleExtId,
  }) {
    final int chapter = verseData['chapter'] as int;
    final int verseNum = verseData['verse'] as int;

    String verseText = verseData['text'] as String;
    bool isParagraphStart =
        verseText.startsWith('\n') || verseText.startsWith('\r\n');
    verseText = verseText.trim();

    final String encodedSpans = jsonEncode([
      {"text": verseText, "activeStyles": []}
    ]);

    return VerseSegmentDto(
      bibleId: bibleExtId.hashCode,
      bookToken: book.osis,
      chapterNumber: chapter,
      verseNumber: verseNum,
      segmentIndex: 0,
      paragraphStart: isParagraphStart,
      spansJson: encodedSpans,
    );
  }
}

extension VerseSegmentDtoMapper on VerseSegmentDto {
  /// Maps the database-friendly DTO into a pure Domain Entity.
  /// Handles also the deserialization of the JSON rich-text spans.
  VerseSegment toDomain() {
    late final List<VerseSpan> domainSpans;
    // Decode the raw JSON string from SQLite into a list of maps
    if (spansJson == null) {
      domainSpans = [];
    } else {
      final List<dynamic> decodedJson = jsonDecode(spansJson!) as List<dynamic>;
      // Parse each raw JSON map into a pure Domain VerseSpan
      domainSpans = decodedJson.map((dynamic item) {
        final Map<String, dynamic> spanMap = item as Map<String, dynamic>;

        return VerseSpan(
          activeStyles: _parseSetOfStyles(spanMap['activeStyles']),
          text: spanMap['text'] as String? ?? '',
          payload: spanMap['payload'] as String?,
        );
      }).toList();
    }

    return VerseSegment(
      segmentIndex: segmentIndex,
      isParagraphStart: paragraphStart,
      heading: heading,
      spans: domainSpans,
    );
  }

  Set<SpanType> _parseSetOfStyles(dynamic activeStyles) {
    final List<dynamic> styleNames = activeStyles;
    final Set<SpanType> styles = styleNames
        .map((name) => SpanType.values.firstWhere((e) => e.name == name))
        .toSet();

    return styles;
  }
}
