import 'package:equatable/equatable.dart';

enum SpanType {
  bold,
  italic,
  underline,
  smallCaps,
  superscript,
  strongWords,
  footnote,
  redLetter,
  poetry,
  wordOfJesus,
  reference,
  crossReference
}

class VerseSpan extends Equatable {
  final int? verseSegmentId;
  final int startOffset;
  final int endOffset;
  final SpanType type;
  final String? payload; // could later become structured

  const VerseSpan({
    this.verseSegmentId,
    required this.startOffset,
    required this.endOffset,
    required this.type,
    this.payload,
  });

  @override
  List<Object?> get props => [
        verseSegmentId,
        startOffset,
        endOffset,
        type,
        payload,
      ];
}
