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
        type: _parseSpanType(spanMap['type'] as String? ?? 'normal'),
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

  /// Safely converts the string type from database JSON back into the Domain Enum.
  SpanType _parseSpanType(String typeStr) {
    try {
      return SpanType.values.byName(typeStr);
    } catch (_) {
      return SpanType.normal;
    }
  }

  // Not needed anymore, fix is applied at the import level

  // List<VerseSpan> _normalizeSpans(List<VerseSpan> spans) {
  //   final result = <VerseSpan>[];

  //   for (var i = 0; i < spans.length; i++) {
  //     final span = spans[i];

  //     // Fix 2: collapse XML line-wrap whitespace into single spaces
  //     final cleanText =
  //         span.text.replaceAll('\n', ' ').replaceAll(RegExp(r' +'), ' ');

  //     // Fix 1: ensure a trailing space before the next word-starting span
  //     final needsTrailingSpace = cleanText.isNotEmpty &&
  //         !cleanText.endsWith(' ') &&
  //         i + 1 < spans.length &&
  //         spans[i + 1].text.isNotEmpty &&
  //         !spans[i + 1].text.startsWith(' ') &&
  //         !spans[i + 1].text.startsWith(',') &&
  //         !spans[i + 1].text.startsWith('.') &&
  //         !spans[i + 1].text.startsWith(';') &&
  //         !spans[i + 1].text.startsWith(':') &&
  //         !spans[i + 1].text.startsWith('!') &&
  //         !spans[i + 1].text.startsWith('?');

  //     result.add(VerseSpan(
  //       type: span.type,
  //       text: needsTrailingSpace ? '$cleanText ' : cleanText,
  //       payload: span.payload,
  //     ));
  //   }

  //   return result;
  // }
}
