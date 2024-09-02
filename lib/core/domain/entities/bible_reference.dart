import 'package:equatable/equatable.dart';

class BibleReference extends Equatable {
  final String book;
  final int chapter;
  final int verse;

  const BibleReference({
    this.book = '',
    this.chapter = 0,
    this.verse = 0,
  });

  @override
  List<Object> get props => [book, chapter, verse];
}
