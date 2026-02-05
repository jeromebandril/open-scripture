import 'package:open_scripture/core/data/models/segment_key.dart';
import 'package:open_scripture/core/domain/entities/verse_span.dart';

class VerseSpanModel extends VerseSpan {
  final SegmentKey? key;

  const VerseSpanModel({
    this.key,
    super.verseSegmentId,
    required super.startOffset,
    required super.endOffset,
    required super.type,
    super.payload,
  });

  factory VerseSpanModel.fromJson(Map<String, dynamic> json) {
    return VerseSpanModel(
      verseSegmentId: json['segmentId'] as int,
      startOffset: json['startOffset'] as int,
      endOffset: json['endOffset'] as int,
      type: SpanType.values[json['spanType'] as int],
      payload: json['payload'] as String?,
    );
  }
}
