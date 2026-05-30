import 'dart:convert';

import 'package:open_scripture/shared/domain/entities/verse.dart';

class VerseSegmentDto {
  final int bibleId;
  final String bookToken;
  final int chapterNumber;
  final int verseNumber;
  final int segmentIndex;
  final bool paragraphStart;
  final String? heading;
  final String spansJson;

  VerseSegmentDto({
    required this.bibleId,
    required this.bookToken,
    required this.chapterNumber,
    required this.verseNumber,
    required this.segmentIndex,
    required this.paragraphStart,
    this.heading,
    required this.spansJson,
  });
}

extension VerseSegmentDtoMapper on VerseSegmentDto {
  /// Maps the database-friendly DTO into a pure Domain Entity.
  /// Handles also the deserialization of the JSON rich-text spans.
  VerseSegment toDomain() {
    // Decode the raw JSON string from SQLite into a list of maps
    final List<dynamic> decodedJson = jsonDecode(spansJson) as List<dynamic>;

    // Parse each raw JSON map into a pure Domain VerseSpan
    final List<VerseSpan> domainSpans = decodedJson.map((dynamic item) {
      final Map<String, dynamic> spanMap = item as Map<String, dynamic>;

      return VerseSpan(
        activeStyles: _parseSetOfStyles(spanMap['activeStyles']),
        text: spanMap['text'] as String? ?? '',
        payload: spanMap['payload'] as String?,
      );
    }).toList();

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
