import 'package:equatable/equatable.dart';

class Verse extends Equatable {
  final int id;
  final int paragraphId;
  final int verseNumber;
  final String verseText;
  final int chapterNumber;

  const Verse({
    required this.id,
    required this.paragraphId,
    required this.verseNumber,
    required this.verseText,
    required this.chapterNumber,
  });

  @override
  List<Object?> get props => [
        id,
        paragraphId,
        verseNumber,
        verseText,
        chapterNumber,
      ];
}
