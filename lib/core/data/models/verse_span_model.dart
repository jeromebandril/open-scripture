import 'package:the_smyrna_bible_v2/core/data/models/segment_key.dart';
import 'package:the_smyrna_bible_v2/core/domain/entities/verse_span.dart';

class VerseSpanModel extends VerseSpan {
  final SegmentKey key;

  const VerseSpanModel({
    required this.key,
    required super.startOffset,
    required super.endOffset,
    required super.type,
    required super.payload,
  });
}
