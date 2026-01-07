import 'package:equatable/equatable.dart';

enum SpanType {
  bold,
  italic,
  underline,
  smallCaps,
  superscript,
  crossReference,
  footnote,
  redLetter,
  poetry,
  wordOfJesus,
  reference,
}

class VerseSpan extends Equatable {
  final int startOffset;
  final int endOffset;
  final SpanType type;
  final String? payload; // could later become structured

  const VerseSpan({
    required this.startOffset,
    required this.endOffset,
    required this.type,
    this.payload,
  });

  @override
  List<Object?> get props => [startOffset, endOffset, type, payload];
}
