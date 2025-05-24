import '../../domain/entities/verse.dart';

class VerseModel extends Verse {
  const VerseModel({
    required super.id,
    required super.paragraphId,
    required super.verseNumber,
    required super.verseText,
    required super.chapterNumber,
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

  Verse toDomain() {
    return Verse(
      id: id,
      paragraphId: paragraphId,
      verseNumber: verseNumber,
      verseText: verseText,
      chapterNumber: chapterNumber,
    );
  }
}
