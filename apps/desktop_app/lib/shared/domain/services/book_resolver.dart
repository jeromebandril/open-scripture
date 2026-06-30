import '../entities/bible_book.dart';

/// Repository responsible for translating human-readable text into
/// strict domain coordinates [BibleBook].
abstract class BookResolver {
  /// Takes a raw user input string (e.g., "1 Sam", "Génesis", "Jn") and attempts
  /// to resolve it to a specific [BibleBook] using localized metadata.
  ///
  /// Returns `null` if no match is found.
  Future<BibleBook?> resolve(String input, int? bibleId);

  /// (Optional) Takes a raw user input string and returns a list of potential matches.
  /// Useful if you want to show a dropdown of suggestions when a user's input is ambiguous.
  Future<List<BibleBook>> resolveCandidates(String userInput, int languageId,
      {int limit = 10});
}
