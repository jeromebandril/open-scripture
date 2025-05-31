import 'package:equatable/equatable.dart';

class EParagraph extends Equatable {
  final int bookName;
  final int chapterNumber;
  final String? subtitle;
  final int startVerse;
  final int endVerse;

  const EParagraph({
    required this.bookName,
    required this.chapterNumber,
    this.subtitle,
    required this.startVerse,
    required this.endVerse,
  });

  @override
  List<Object?> get props =>
      [bookName, chapterNumber, subtitle, startVerse, endVerse];
}
