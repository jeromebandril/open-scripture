import 'package:equatable/equatable.dart';

import 'bible_ref.dart';

class VerseSpan extends Equatable {
  final int startOffset;
  final int endOffset;
  final String type;
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
