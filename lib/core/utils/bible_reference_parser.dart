import 'package:collection/collection.dart';

import '../domain/entities/bible_ref.dart';
import '../error/failure.dart';

class BibleReferenceParser {
  static const searchPromptRegex =
      // r"(\d*\s*[a-zA-Z\s]+)(\d*)\D*(\d*)"; // version 1 (no verse end)
      r'^(.+?)\s+(\d+)(?::(\d+)(?:-(\d+))?)?$'; // version 2

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
  static const Map<String, String> bibleBookNameToSwordId = {
    'Genesis': 'Gen',
    'Exodus': 'Exod',
    'Leviticus': 'Lev',
    'Numbers': 'Num',
    'Deuteronomy': 'Deut',
    'Joshua': 'Josh',
    'Judges': 'Judg',
    'Ruth': 'Ruth',
    '1 Samuel': '1Sam',
    '2 Samuel': '2Sam',
    '1 Kings': '1Kgs',
    '2 Kings': '2Kgs',
    '1 Chronicles': '1Chr',
    '2 Chronicles': '2Chr',
    'Ezra': 'Ezra',
    'Nehemiah': 'Neh',
    'Esther': 'Esth',
    'Job': 'Job',
    'Psalms': 'Ps',
    'Proverbs': 'Prov',
    'Ecclesiastes': 'Eccl',
    'Song of Songs': 'Song',
    'Isaiah': 'Isa',
    'Jeremiah': 'Jer',
    'Lamentations': 'Lam',
    'Ezekiel': 'Ezek',
    'Daniel': 'Dan',
    'Hosea': 'Hos',
    'Joel': 'Joel',
    'Amos': 'Amos',
    'Obadiah': 'Obad',
    'Jonah': 'Jonah',
    'Micah': 'Mic',
    'Nahum': 'Nah',
    'Habakkuk': 'Hab',
    'Zephaniah': 'Zeph',
    'Haggai': 'Hag',
    'Zechariah': 'Zech',
    'Malachi': 'Mal',
    'Matthew': 'Matt',
    'Mark': 'Mark',
    'Luke': 'Luke',
    'John': 'John',
    'Acts': 'Acts',
    'Romans': 'Rom',
    '1 Corinthians': '1Cor',
    '2 Corinthians': '2Cor',
    'Galatians': 'Gal',
    'Ephesians': 'Eph',
    'Philippians': 'Phil',
    'Colossians': 'Col',
    '1 Thessalonians': '1Thess',
    '2 Thessalonians': '2Thess',
    '1 Timothy': '1Tim',
    '2 Timothy': '2Tim',
    'Titus': 'Titus',
    'Philemon': 'Phlm',
    'Hebrews': 'Heb',
    'James': 'Jas',
    '1 Peter': '1Pet',
    '2 Peter': '2Pet',
    '1 John': '1John',
    '2 John': '2John',
    '3 John': '3John',
    'Jude': 'Jude',
    'Revelation': 'Rev',
  };
  static const Map<String, String> bibleBookNameTo3CharCode = {
    'Genesis': 'GEN',
    'Exodus': 'EXO',
    'Leviticus': 'LEV',
    'Numbers': 'NUM',
    'Deuteronomy': 'DEU',
    'Joshua': 'JOS',
    'Judges': 'JDG',
    'Ruth': 'RUT',
    '1 Samuel': '1SA',
    '2 Samuel': '2SA',
    '1 Kings': '1KI',
    '2 Kings': '2KI',
    '1 Chronicles': '1CH',
    '2 Chronicles': '2CH',
    'Ezra': 'EZR',
    'Nehemiah': 'NEH',
    'Esther': 'EST',
    'Job': 'JOB',
    'Psalms': 'PSA',
    'Proverbs': 'PRO',
    'Ecclesiastes': 'ECC',
    'Song of Songs': 'SNG',
    'Isaiah': 'ISA',
    'Jeremiah': 'JER',
    'Lamentations': 'LAM',
    'Ezekiel': 'EZK',
    'Daniel': 'DAN',
    'Hosea': 'HOS',
    'Joel': 'JOL',
    'Amos': 'AMO',
    'Obadiah': 'OBA',
    'Jonah': 'JON',
    'Micah': 'MIC',
    'Nahum': 'NAM',
    'Habakkuk': 'HAB',
    'Zephaniah': 'ZEP',
    'Haggai': 'HAG',
    'Zechariah': 'ZEC',
    'Malachi': 'MAL',
    'Matthew': 'MAT',
    'Mark': 'MRK',
    'Luke': 'LUK',
    'John': 'JHN',
    'Acts': 'ACT',
    'Romans': 'ROM',
    '1 Corinthians': '1CO',
    '2 Corinthians': '2CO',
    'Galatians': 'GAL',
    'Ephesians': 'EPH',
    'Philippians': 'PHP',
    'Colossians': 'COL',
    '1 Thessalonians': '1TH',
    '2 Thessalonians': '2TH',
    '1 Timothy': '1TI',
    '2 Timothy': '2TI',
    'Titus': 'TIT',
    'Philemon': 'PHM',
    'Hebrews': 'HEB',
    'James': 'JAS',
    '1 Peter': '1PE',
    '2 Peter': '2PE',
    '1 John': '1JN',
    '2 John': '2JN',
    '3 John': '3JN',
    'Jude': 'JUD',
    'Revelation': 'REV',
  };

  MapEntry<String, String>? _findByKeyPrefix(
    Map<String, String> map,
    String prefix,
  ) {
    return map.entries.firstWhereOrNull(
      (e) => e.key.toLowerCase().startsWith(prefix.toLowerCase()),
    );
  }

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
      final verseStartStr = match.group(3)?.trim();
      final verseEndStr = match.group(4)?.trim();
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
      final book3CharId =
          _findByKeyPrefix(bibleBookNameTo3CharCode, book)?.value;
      if (book3CharId == null) throw Exception();
      //
      // Parse chapter and verse, default to 1 if not specified
      //
      final chapter =
          chapterStr == null || chapterStr.isEmpty ? 1 : int.parse(chapterStr);
      final verseStart = verseStartStr == null || verseStartStr.isEmpty
          ? 1
          : int.parse(verseStartStr);
      final verseEnd = verseEndStr != null ? int.parse(verseEndStr) : null;
      //
      // result
      //
      final BibleRef reference = BibleRef(
        bookOsisId: book3CharId.toUpperCase(),
        chapter: chapter, // corrections for zero based counting
        verseStart: verseStart,
        verseEnd: verseEnd,
      );
      return Future.value(reference);
    } catch (e) {
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
