import 'package:equatable/equatable.dart';

class BibleRef extends Equatable {
  final String bookOsisId;
  final int chapter;
  final int? verseStart;
  final int? verseEnd;

  const BibleRef({
    required this.bookOsisId,
    required this.chapter,
    this.verseStart,
    this.verseEnd,
  });

  @override
  List<Object?> get props => [bookOsisId, chapter, verseStart, verseEnd];
}
