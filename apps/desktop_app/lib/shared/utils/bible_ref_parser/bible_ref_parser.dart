import '../../domain/entities/bible_ref_partial.dart';
import 'error/bible_ref_parser_exceptions.dart';

class BibleRefParser {
  static const _searchPromptRegex =
      r'^(.+?)\s+(\d+)(?:[:. ](\d+)(?:-(\d+))?)?$';

  Future<BibleRefPartial> parse(String rawReference) async {
    final match = RegExp(_searchPromptRegex).firstMatch(rawReference.trim());

    if (match == null) {
      throw const BibleRefInvalidFormatException(
        'Invalid reference format. Example: "John 3:16".',
      );
    }

    final rawBook = match.group(1)?.trim();
    if (rawBook == null || rawBook.isEmpty) {
      throw const BibleRefInvalidFormatException('Missing book name.');
    }

    // 1. Clean and rebuild book token for the resolver
    final cleanedBook = rawBook
        .replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    final bookToken = cleanedBook.replaceAllMapped(
      RegExp(r'(\d)([a-zA-Z])'),
      (match) => '${match[1]} ${match[2]}',
    );

    // 2. Delegate to the strategy chain!
    // The parser doesn't care if this is resolved via Enum, SQLite, or an API.
    // final book = await _bookResolver.resolve(bookToken, languageId);

    // if (book == null) {
    //   throw BibleRefUnknownBookException('Book not found: "$rawBook".');
    // }

    // 3. Extract and validate coordinates
    final chapterStr = match.group(2)?.trim();
    final verseStartStr = match.group(3)?.trim();
    final verseEndStr = match.group(4)?.trim();

    final chapter =
        chapterStr == null || chapterStr.isEmpty ? 1 : int.parse(chapterStr);
    final verseStart = verseStartStr == null || verseStartStr.isEmpty
        ? 1
        : int.parse(verseStartStr);
    final verseEnd = verseEndStr == null ? null : int.parse(verseEndStr);

    if (chapter <= 0) {
      throw BibleRefOutOfRangeException('Chapter must be >= 1.');
    }
    if (verseStart <= 0) {
      throw BibleRefOutOfRangeException('Verse must be >= 1.');
    }
    if (verseEnd != null && verseEnd < verseStart) {
      throw BibleRefOutOfRangeException('Verse end must be >= verse start.');
    }

    // 4. Return the Domain Entity
    return BibleRefPartial(
      bookToken: bookToken,
      chapter: chapter,
      verseStart: verseStart,
      verseEnd: verseEnd,
    );
  }
}
