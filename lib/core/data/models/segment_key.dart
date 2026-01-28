import 'package:equatable/equatable.dart';

class SegmentKey extends Equatable {
  final String bookUsfxId;
  final int chapter;
  final int verse;
  final int segmentIndex;

  const SegmentKey({
    required this.bookUsfxId,
    required this.chapter,
    required this.verse,
    required this.segmentIndex,
  });

  @override
  List<Object?> get props => [bookUsfxId, chapter, verse, segmentIndex];
}
