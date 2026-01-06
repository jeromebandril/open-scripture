import 'package:fpdart/fpdart.dart';

import '../domain/entities/bible_ref.dart';
import '../error/failure.dart';

class BibleReferenceParser {
  static const searchPromptRegex = r"(\d*\s*[a-zA-Z\s]+)(\d*)\D*(\d*)";
  static const List<String> kjvBooks = [
    "Genesis",
    "Exodus",
    "Leviticus",
    "Numbers",
    "Deuteronomy",
    "Joshua",
    "Judges",
    "Ruth",
    "1 Samuel",
    "2 Samuel",
    "1 Kings",
    "2 Kings",
    "1 Chronicles",
    "2 Chronicles",
    "Ezra",
    "Nehemiah",
    "Esther",
    "Job",
    "Psalms",
    "Proverbs",
    "Ecclesiastes",
    "Song of Solomon",
    "Isaiah",
    "Jeremiah",
    "Lamentations",
    "Ezekiel",
    "Daniel",
    "Hosea",
    "Joel",
    "Amos",
    "Obadiah",
    "Jonah",
    "Micah",
    "Nahum",
    "Habakkuk",
    "Zephaniah",
    "Haggai",
    "Zechariah",
    "Malachi",
    "Matthew",
    "Mark",
    "Luke",
    "John",
    "Acts",
    "Romans",
    "1 Corinthians",
    "2 Corinthians",
    "Galatians",
    "Ephesians",
    "Philippians",
    "Colossians",
    "1 Thessalonians",
    "2 Thessalonians",
    "1 Timothy",
    "2 Timothy",
    "Titus",
    "Philemon",
    "Hebrews",
    "James",
    "1 Peter",
    "2 Peter",
    "1 John",
    "2 John",
    "3 John",
    "Jude",
    "Revelation",
  ];
  static const List<String> kjvAbbreviations = [
    'Gen',
    'Exod',
    'Lev',
    'Num',
    'Deut',
    'Josh',
    'Judg',
    'Ruth',
    '1Sam',
    '2Sam',
    '1Kings',
    '2Kings',
    '1Chron',
    '2Chron',
    'Ezra',
    'Neh',
    'Esther',
    'Job',
    'Psa',
    'Prov',
    'Eccl',
    'Song of Sol',
    'Isa',
    'Jer',
    'Lam',
    'Ezek',
    'Dan',
    'Hos',
    'Joel',
    'Amos',
    'Obad',
    'Jonah',
    'Mic',
    'Nah',
    'Hab',
    'Zeph',
    'Hag',
    'Zech.',
    'Ma.',
    'Matt',
    'Mark',
    'Luke',
    'John',
    'Acts',
    'Rom',
    '1Cor',
    '2Cor',
    'Gal',
    'Eph',
    'Phil',
    'Col',
    '1Thess',
    '2Thess',
    '1Tim',
    '2Tim',
    'Titus',
    'Philem',
    'Heb',
    'James',
    '1Pet',
    '2Pet',
    '1John',
    '2John',
    '3John',
    'Jude',
    'Rev',
  ];

  Future<BibleRef> analyze(String text) async {
    try {
      //
      // Extract book and chapter+verse information
      //
      final match = RegExp(searchPromptRegex).firstMatch(text);
      //
      // check if the match on prompt is actually catching something,
      //otherwise it's surely not formatted correctly
      //
      if (match == null) throw Exception();
      //
      // extrapolate book, chapter and verse as strings as they were in prompt
      //
      final rawBook = match.group(1)?.trim();
      final chapterStr = match.group(2)?.trim();
      final verseStr = match.group(3)?.trim();
      //
      // normalize book name by clearing from special characters
      //
      final cleanedBook = rawBook!.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
      //
      // rebuild book name if there's a digit (e.g   '1john' => '1 john')
      //
      final book = cleanedBook.replaceAllMapped(
        RegExp(r'(\d)([a-zA-Z])'),
        (match) => '${match[1]} ${match[2]}',
      );
      //
      // Parse chapter and verse, default to 1 if not specified
      //
      final chapter = chapterStr!.isEmpty ? 1 : int.parse(chapterStr);
      final verse = verseStr!.isEmpty ? 1 : int.parse(verseStr);
      //
      // check book validity
      //
      int result = kjvBooks.indexWhere(
        (bookName) => bookName.toLowerCase().startsWith(
              book.toLowerCase(),
            ),
      );
      if (result == -1) throw Exception();
      //
      // result
      //
      final BibleRef reference = BibleRef(
        bookOsisId: book.toUpperCase(),
        chapter: chapter - 1, // corrections for zero based counting
        verseStart: verse - 1,
        verseEnd: null,
      );
      return Future.value(reference);
    } on Exception {
      throw Error();
    }
  }
}

class InvalidInputFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class InvalidInputException implements Exception {
  InvalidInputException();
}
