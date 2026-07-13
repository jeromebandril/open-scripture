import 'package:drift/drift.dart';
import '../../../../core/infrastructure/database/database.dart';
import '../../../domain/entities/bible_book.dart';
import '../../../domain/services/book_resolver.dart';

/// Database / Localized Lookup
/// Hits SQLite to find localized names or aliases (e.g., "Génesis", "1 Sam").
class DriftBookResolver implements BookResolver {
  final AppDb _db;

  DriftBookResolver(this._db);

  @override
  Future<BibleBook?> resolve(String input, int? bibleId) async {
    if (bibleId == null) return null;
    // throw UnimplementedError();
    final sanitizedInput = input.trim().toLowerCase();
    if (sanitizedInput.isEmpty) return null;

    // For '1 Sam' matching '1 Samuel'
    final prefixMatch = '$sanitizedInput%';
    // For finding 'sos' inside 'sng, song, sos'
    final containsMatch = '%$sanitizedInput%';

    // Build the Drift query with a Join
    final query = _db.select(_db.localizedBookNames).join([
      innerJoin(
        _db.canonicalBooks,
        _db.canonicalBooks.id.equalsExp(_db.localizedBookNames.bookId),
      ),
    ])
      ..where(_db.localizedBookNames.bibleId.equals(bibleId) &
          (_db.localizedBookNames.longName.lower().like(containsMatch) |
              _db.localizedBookNames.shortName.lower().like(containsMatch) |
              _db.localizedBookNames.abbr.lower().like(prefixMatch) |
              _db.localizedBookNames.aliases.lower().like(containsMatch)))
      ..limit(1);

    final result = await query.getSingleOrNull();

    if (result == null) return null;

    // Extract the strict programmatic token from the canonical table
    final canonicalRow = result.readTable(_db.canonicalBooks);
    return BibleBook.fromProgrammaticId(canonicalRow.bookToken);
  }

  @override
  Future<List<BibleBook>> resolveCandidates(String userInput, int languageId,
      {int limit = 10}) async {
    throw UnimplementedError();
    // final sanitizedInput = userInput.trim().toLowerCase();
    // if (sanitizedInput.isEmpty) return [];

    // final prefixMatch = '$sanitizedInput%';
    // final containsMatch = '%$sanitizedInput%';

    // final query = _db.select(_db.localizedBookNames).join([
    //   innerJoin(
    //     _db.canonicalBooks,
    //     _db.canonicalBooks.id.equalsExp(_db.localizedBookNames.bookId),
    //   ),
    // ])
    //   ..where(_db.localizedBookNames.languageId.equals(languageId) &
    //       (_db.localizedBookNames.longName.lower().like(prefixMatch) |
    //           _db.localizedBookNames.shortName.lower().like(prefixMatch) |
    //           _db.localizedBookNames.abbr.lower().like(prefixMatch) |
    //           _db.localizedBookNames.aliases.lower().like(containsMatch)))
    //   ..orderBy([OrderingTerm.asc(_db.canonicalBooks.bookOrder)])
    //   ..limit(limit);

    // final results = await query.get();

    // return results
    //     .map((row) => BibleBook.fromProgrammaticId(
    //         row.readTable(_db.canonicalBooks).bookToken))
    //     .whereType<BibleBook>() // Filters out nulls
    //     .toList();
  }
}
