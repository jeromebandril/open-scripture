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

    final prefixMatch = '$sanitizedInput%';
    final containsMatch = '%$sanitizedInput%';

    final localized = _db.localizedBookNames;
    final canonical = _db.canonicalBooks;
    // Filter with proprity
    final matchRank = CaseWhenExpression<int>(
      cases: [
        // Exact abbreviation: "eph" == "EPH"
        CaseWhen(
          localized.abbr.lower().isValue(sanitizedInput),
          then: const Constant(1),
        ),
        // Abbreviation prefix: "eph%"
        CaseWhen(
          localized.abbr.lower().like(prefixMatch),
          then: const Constant(2),
        ),
        // Exact short name: "ephesians"
        CaseWhen(
          localized.shortName.lower().isValue(sanitizedInput),
          then: const Constant(3),
        ),
        // Short name prefix: "eph%"
        CaseWhen(
          localized.shortName.lower().like(prefixMatch),
          then: const Constant(4),
        ),
        // Long name contains: "%eph%"
        CaseWhen(
          localized.longName.lower().like(containsMatch),
          then: const Constant(5),
        ),
        // Alias contains: "%eph%"
        CaseWhen(
          localized.aliases.lower().like(containsMatch),
          then: const Constant(6),
        ),
      ],
      orElse: const Constant(99),
    );

    final query = _db.select(localized).join([
      innerJoin(
        canonical,
        canonical.id.equalsExp(localized.bookId),
      ),
    ])
      ..where(
        localized.bibleId.equals(bibleId) &
            (localized.abbr.lower().like(prefixMatch) |
                localized.shortName.lower().like(prefixMatch) |
                localized.longName.lower().like(containsMatch) |
                localized.aliases.lower().like(containsMatch)),
      )
      ..orderBy([
        OrderingTerm.asc(matchRank),
        OrderingTerm.asc(canonical.id),
      ])
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
