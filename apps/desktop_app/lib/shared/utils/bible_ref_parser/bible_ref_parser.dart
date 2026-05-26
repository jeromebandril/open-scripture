import 'package:open_scripture/core/infrastructure/book_resolver/book_resolver.dart';

import '../../entities/bible_ref.dart';
import 'bible_ref_parser_exceptions.dart';

class BibleReferenceParser {
  BibleReferenceParser({
    BibleRefResolver? resolver,
  }) : _resolver = resolver ?? BibleRefResolver.defaultResolver();

  final BibleRefResolver _resolver;

  static const searchPromptRegex =
      // r"(\d*\s*[a-zA-Z\s]+)(\d*)\D*(\d*)"; // version 1 (no verse end)
      r'^(.+?)\s+(\d+)(?:[:. ](\d+)(?:-(\d+))?)?$'; // version 2

  BibleRef analyze(String text) {
    //
    // Extract book and chapter+verse information
    //
    final match = RegExp(searchPromptRegex).firstMatch(text.trim());
    //
    // check if the match on prompt is actually catching something,
    //otherwise it's surely not formatted correctly
    //
    if (match == null) {
      throw const BibleRefInvalidFormatException(
        'Invalid reference format. Example: "John 3:16" or "1 John 1:1-3".',
      );
    }
    //
    // extrapolate book, chapter and verse as strings as they were in prompt
    //
    final rawBook = match.group(1)?.trim();
    if (rawBook == null || rawBook.isEmpty) {
      throw const BibleRefInvalidFormatException('Missing book name.');
    }

    final chapterStr = match.group(2)?.trim();
    final verseStartStr = match.group(3)?.trim();
    final verseEndStr = match.group(4)?.trim();
    //
    // normalize book name by clearing from special characters
    //
    final cleanedBook = rawBook
        .replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (cleanedBook.isEmpty) {
      throw const BibleRefInvalidFormatException('Book name is empty.');
    }
    //
    // rebuild book name if there's a digit (e.g   '1john' => '1 john')
    //
    final bookToken = cleanedBook.replaceAllMapped(
      RegExp(r'(\d)([a-zA-Z])'),
      (match) => '${match[1]} ${match[2]}',
    );
    final book = _resolver.resolveBook(bookToken);

    if (book == null) {
      // Distinguish unknown vs ambiguous: offer candidates
      final candidates = _resolver.resolveCandidates(bookToken);

      if (candidates.isNotEmpty) {
        throw BibleRefAmbiguousBookException(
          'Ambiguous book: "$rawBook".',
          candidates: candidates.map((b) => b.fullName).toList(growable: false),
        );
      }

      throw BibleRefUnknownBookException('Book not found: "$rawBook".');
    }
    //
    // Parse chapter and verse, default to 1 if not specified
    //
    final chapter =
        chapterStr == null || chapterStr.isEmpty ? 1 : int.parse(chapterStr);
    final verseStart = verseStartStr == null || verseStartStr.isEmpty
        ? 1
        : int.parse(verseStartStr);
    final verseEnd = verseEndStr == null ? null : int.parse(verseEndStr);
    //
    // Sanity constraints
    //
    if (chapter <= 0) {
      throw BibleRefOutOfRangeException('Chapter must be >= 1 (got $chapter).');
    }
    if (verseStart <= 0) {
      throw BibleRefOutOfRangeException(
          'Verse must be >= 1 (got $verseStart).');
    }
    if (verseEnd != null && verseEnd < verseStart) {
      throw BibleRefOutOfRangeException(
        'Verse end must be >= verse start ($verseStart-$verseEnd).',
      );
    }
    //
    // result
    //
    final BibleRef reference = BibleRef(
      bookUsfxId: book.usfxId,
      chapter: chapter,
      verseStart: verseStart,
      verseEnd: verseEnd,
    );
    return reference;
  }
}
