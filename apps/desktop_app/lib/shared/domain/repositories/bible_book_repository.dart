import 'package:open_scripture/shared/domain/entities/bible_id.dart';
import 'package:open_scripture/shared/domain/entities/localized_book.dart';

/// The abstraction boundary for retrieving Bible book names and structures.
abstract class BibleBookRepository {
  /// Fetches all 66 books, translated for a specific language, in canonical order.
  /// Useful for populating the "Book Picker" in the UI.
  Future<List<LocalizedBook>> getBooksForBibleTranslation(BibleId bibleId);

  /// Delegates user search to highly optimized SQLite text search.
  /// Returns a list of candidates matching the query in the given language.
  Future<List<LocalizedBook>> searchBookByName(String query, int languageId);
}
