import 'package:the_smyrna_bible_v2/core/data/models/segment_key.dart';
import 'package:the_smyrna_bible_v2/core/domain/entities/verse_span.dart';

class VerseSpanModel extends VerseSpan {
  final SegmentKey key;

  const VerseSpanModel({
    required this.key,
    super.verseSegmentId,
    required super.startOffset,
    required super.endOffset,
    required super.type,
    super.payload,
  });

  factory VerseSpanModel.fromJson(Map<String, dynamic> json) {
    print(json['segmentId']);
    if (json['segmentId'] == null) print('null segmentid');
    if (json['startOffset'] == null) print('null start');
    if (json['endOffset'] == null) print('null end');
    if (json['spanType'] == null) print('null tpye');

    return VerseSpanModel(
      verseSegmentId: json['segmentId'] as int,
      key: SegmentKey(
        bookOsisId: '',
        chapter: 0,
        verse: 0,
        segmentIndex: 0,
      ),
      startOffset: json['startOffset'] as int,
      endOffset: json['endOffset'] as int,
      type: SpanType.values[json['spanType'] as int],
      payload: json['payload'] as String?,
    );
  }
}
