import 'package:equatable/equatable.dart';

class BibleReference extends Equatable {
  final String book;
  final int chapter;
  final int verse;

  const BibleReference({
    required this.book,
    required this.chapter,
    required this.verse,
  });

  @override
  List<Object?> get props => [book, chapter, verse];
}
