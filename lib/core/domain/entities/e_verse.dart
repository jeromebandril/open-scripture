import 'package:equatable/equatable.dart';

class EVerse extends Equatable {
  final int paragraphId;
  final int verseNumber;
  final String verseText;
  final int chapterNumber;

  const EVerse({
    required this.paragraphId,
    required this.verseNumber,
    required this.verseText,
    required this.chapterNumber,
  });

  @override
  List<Object?> get props => [
        paragraphId,
        verseNumber,
        verseText,
        chapterNumber,
      ];
}
