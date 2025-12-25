import 'package:equatable/equatable.dart';

import 'bible_ref.dart';

class VerseSpan extends Equatable {
  final int startOffset;
  final int endOffset;
  final String type;
  final String? payload; // could later become structured

  const VerseSpan(
      {required this.startOffset,
      required this.endOffset,
      required this.type,
      this.payload});

  @override
  List<Object?> get props => [startOffset, endOffset, type, payload];
}

class VerseSegment extends Equatable {
  final BibleRef ref; // (bookId, chapter, verse)
  final int segmentIndex;
  final bool paragraphStart;
  final String textContent;
  final String? subtitle;
  final List<VerseSpan> spans;

  const VerseSegment({
    required this.ref,
    required this.segmentIndex,
    required this.paragraphStart,
    required this.textContent,
    required this.subtitle,
    required this.spans,
  });

  @override
  List<Object?> get props => [
        ref,
        segmentIndex,
        paragraphStart,
        textContent,
        subtitle,
        spans,
      ];
}
