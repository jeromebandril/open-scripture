import 'package:open_scripture/shared/domain/entities/bible_book.dart';
import 'package:open_scripture/shared/domain/services/book_resolver.dart';

/// Internal/Default Identifier Lookup
/// Checks against OSIS and USFM programmatic IDs directly via the enum.
class ProgrammaticIdResolver implements BookResolver {
  @override
  Future<BibleBook?> resolve(String input, int? languageId) async {
    // Step 1: Strict programmatic token check (e.g., 'GEN', '1MA')
    final strictMatch = BibleBook.fromProgrammaticId(input);
    if (strictMatch != null) return strictMatch;

    // Step 2: English alias check (e.g., 'john', 'jn')
    final englishMatch = BibleBook.resolveEnglishAlias(input);
    if (englishMatch != null) return englishMatch;

    // Step 3: Prefix English name check ('gene' -> Genesis)
    final prefixMatch = BibleBook.resolveEnglishPrefix(input);
    if (prefixMatch != null) return prefixMatch;

    return null;
  }

  @override
  Future<List<BibleBook>> resolveCandidates(
    String userInput,
    int languageId, {
    int limit = 5,
  }) async {
// Using a Set prevents duplicate entries if a book matches multiple ways
    final candidates = <BibleBook>{};

    // 1. Always put an exact match at the very top of the list if it exists
    final exactMatch = await resolve(userInput, languageId);
    if (exactMatch != null) {
      candidates.add(exactMatch);
    }

    // 2. Fetch all books whose full name starts with the user input
    // (e.g. typing "Jo" yields John, Joshua, Jonah, Joel, Job)
    final prefixMatches = BibleBook.resolveEnglishPrefixCandidates(userInput);
    candidates.addAll(prefixMatches);

    // Convert back to a list and respect the limit
    return candidates.take(limit).toList();
  }
}
