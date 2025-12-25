import 'package:equatable/equatable.dart';

class BibleRef extends Equatable {
  final String bookId;
  final int chapter;
  final int? verseStart;
  final int? verseEnd;

  const BibleRef({
    required this.bookId,
    required this.chapter,
    this.verseStart,
    this.verseEnd,
  });

  @override
  List<Object?> get props => [bookId, chapter, verseStart, verseEnd];
}
