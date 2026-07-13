import 'package:equatable/equatable.dart';
import 'bible_book.dart';
import 'bible_ref.dart';

class BibleRefPartial extends Equatable {
  final String bookToken;
  final int chapter;
  final int? verseStart;
  final int? verseEnd;

  const BibleRefPartial({
    required this.bookToken,
    required this.chapter,
    required this.verseStart,
    required this.verseEnd,
  });

  BibleRef toFullRef(BibleBook book) {
    return BibleRef(
      book: book,
      chapter: chapter,
      verseStart: verseStart,
      verseEnd: verseEnd,
    );
  }

  @override
  List<Object?> get props => [bookToken, chapter, verseStart, verseEnd];
}
