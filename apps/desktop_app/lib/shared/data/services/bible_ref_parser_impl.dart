import 'package:open_scripture/shared/domain/entities/bible_ref.dart';
import 'package:open_scripture/shared/domain/services/bible_ref_parser.dart';
import 'package:open_scripture/shared/domain/services/book_resolver.dart';
import 'package:open_scripture/shared/utils/bible_ref_parser/bible_ref_parser_exceptions.dart';

class BibleRefParserImpl implements BibleRefParser {
  final BookResolver _bookResolver;

  // DI injects the resolver (which will be our ChainedBookResolver)
  BibleRefParserImpl({required BookResolver bookResolver})
      : _bookResolver = bookResolver;

  static const _searchPromptRegex =
      r'^(.+?)\s+(\d+)(?:[:. ](\d+)(?:-(\d+))?)?$';

  @override
  Future<BibleRef> parse(String rawReference, {int? languageId}) async {
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
    final book = await _bookResolver.resolve(bookToken, languageId);

    if (book == null) {
      throw BibleRefUnknownBookException('Book not found: "$rawBook".');
    }

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

    if (chapter <= 0)
      throw BibleRefOutOfRangeException('Chapter must be >= 1.');
    if (verseStart <= 0)
      throw BibleRefOutOfRangeException('Verse must be >= 1.');
    if (verseEnd != null && verseEnd < verseStart) {
      throw BibleRefOutOfRangeException('Verse end must be >= verse start.');
    }

    // 4. Return the Domain Entity
    return BibleRef(
      book: book, // Changed to pass the actual enum rather than just usfxId
      chapter: chapter,
      verseStart: verseStart,
      verseEnd: verseEnd,
    );
  }
}
