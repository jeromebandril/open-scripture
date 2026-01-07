import 'package:equatable/equatable.dart';

class SegmentKey extends Equatable {
  final String bookOsisId;
  final int chapter;
  final int verse;
  final int segmentIndex;

  const SegmentKey({
    required this.bookOsisId,
    required this.chapter,
    required this.verse,
    required this.segmentIndex,
  });

  @override
  List<Object?> get props => [bookOsisId, chapter, verse, segmentIndex];
}
