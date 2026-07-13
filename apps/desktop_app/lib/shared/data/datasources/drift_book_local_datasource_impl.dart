import 'package:drift/drift.dart';
import '../../../core/infrastructure/database/database.dart';
import '../models/book_dto.dart';

abstract class BibleBookLocalDataSource {
  Future<List<BookDto>> getBooksForBible(String bibleId);
  Future<List<BookDto>> searchBookByName(String query, int languageId);
}

class DriftBibleBookLocalDataSourceImpl implements BibleBookLocalDataSource {
  final AppDb _db;

  DriftBibleBookLocalDataSourceImpl(this._db);

  @override
  Future<List<BookDto>> getBooksForBible(String bibleId) async {
    final bibleRecord = await (_db.select(_db.bibles)
          ..where((tbl) => tbl.extId.equals(bibleId)))
        .getSingleOrNull();

    if (bibleRecord == null) {
      throw ArgumentError(
          'Bible with id $bibleId does not exist in the database.');
    }

    final query = _db.select(_db.localizedBookNames).join([
      innerJoin(
        _db.canonicalBooks,
        _db.canonicalBooks.id.equalsExp(_db.localizedBookNames.bookId),
      ),
      // Add a join to the bibles table to access the extId
      innerJoin(
        _db.bibles,
        _db.bibles.id.equalsExp(_db.localizedBookNames.bibleId),
      ),
    ])
      // Filter using the bibles.extId instead of localizedBookNames.bibleId
      ..where(_db.bibles.extId.equals(bibleId))
      ..orderBy([OrderingTerm.asc(_db.canonicalBooks.bookOrder)]);

    final results = await query.get();

    // Map Drift's TypedResult to your agnostic BookDto here!
    return results.map((row) {
      final canonical = row.readTable(_db.canonicalBooks);
      final localized = row.readTable(_db.localizedBookNames);
      return BookDto(
        bookToken: canonical.bookToken,
        longName: localized.longName,
        shortName: localized.shortName,
        abbr: localized.abbr,
      );
    }).toList();
  }

  @override
  Future<List<BookDto>> searchBookByName(String query, int languageId) async {
    final sanitizedInput = query.trim().toLowerCase();
    final prefixMatch = '$sanitizedInput%';
    final containsMatch = '%$sanitizedInput%';

    // We join localized_book_names -> bibles -> canonical_books
    final selectQuery = _db.select(_db.localizedBookNames).join([
      innerJoin(
        _db.bibles,
        _db.bibles.id.equalsExp(_db.localizedBookNames.bibleId),
      ),
      innerJoin(
        _db.canonicalBooks,
        _db.canonicalBooks.id.equalsExp(_db.localizedBookNames.bookId),
      ),
    ])
      ..where(_db.bibles.languageId.equals(languageId) &
          (_db.localizedBookNames.longName.lower().like(prefixMatch) |
              _db.localizedBookNames.shortName.lower().like(prefixMatch) |
              _db.localizedBookNames.abbr.lower().like(prefixMatch) |
              _db.localizedBookNames.aliases.lower().like(containsMatch)))
      ..orderBy([OrderingTerm.asc(_db.canonicalBooks.bookOrder)])
      ..addColumns([_db.localizedBookNames.longName]);

    final results = await selectQuery.get();

    // Deduplicate results: different Bibles might have the same longName
    final uniqueResults = <BookDto>[];
    final seenNames = <String>{};

    for (final row in results) {
      final canonical = row.readTable(_db.canonicalBooks);
      final localized = row.readTable(_db.localizedBookNames);

      if (seenNames.add(localized.longName.toLowerCase())) {
        uniqueResults.add(BookDto(
          bookToken: canonical.bookToken,
          longName: localized.longName,
          shortName: localized.shortName,
          abbr: localized.abbr ?? '',
        ));
      }
    }

    return uniqueResults;
  }
}
