import 'package:equatable/equatable.dart';

import '../../domain/entities/e_verse.dart';

class VerseModel extends Equatable {
  final int id;
  final int paragraphId;
  final int verseNumber;
  final String verseText;
  final int chapterNumber;

  const VerseModel({
    required this.id,
    required this.paragraphId,
    required this.verseNumber,
    required this.verseText,
    required this.chapterNumber,
  });

  factory VerseModel.fromDatabase(Map<String, dynamic> map) {
    return VerseModel(
      id: map['id'],
      paragraphId: map['paragraph_id'],
      verseNumber: map['number'],
      verseText: map['text'],
      chapterNumber: map['chapter_number'],
    );
  }

  EVerse toDomain() {
    return EVerse(
      paragraphId: paragraphId,
      verseNumber: verseNumber,
      verseText: verseText,
      chapterNumber: chapterNumber,
    );
  }

  @override
  List<Object?> get props => [
        id,
        paragraphId,
        verseNumber,
        verseText,
        chapterNumber,
      ];
}
