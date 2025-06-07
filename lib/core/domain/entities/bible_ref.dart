import 'package:equatable/equatable.dart';

class BibleRef extends Equatable {
  final String bookName;
  final int chapter;
  final int verse;

  const BibleRef({
    required this.bookName,
    required this.chapter,
    required this.verse,
  });

  @override
  List<Object?> get props => [bookName, chapter, verse];
}
