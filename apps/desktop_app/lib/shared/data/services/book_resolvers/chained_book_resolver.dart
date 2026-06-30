import '../../../domain/entities/bible_book.dart';
import '../../../domain/services/book_resolver.dart';

class ChainedBookResolver implements BookResolver {
  final List<BookResolver> _chain;

  ChainedBookResolver(this._chain);

  @override
  Future<BibleBook?> resolve(String input, int? bibleId) async {
    for (final resolver in _chain) {
      final result = await resolver.resolve(input, bibleId);
      if (result != null) return result;
    }
    // Fallback if no strategy in the chain could resolve the book.
    return null;
  }

  @override
  Future<List<BibleBook>> resolveCandidates(String userInput, int languageId,
      {int limit = 10}) {
    // TODO: implement resolveCandidates
    throw UnimplementedError();
  }
}
