import '../../domain/entities/bible_book.dart';
import '../../domain/entities/bible_id.dart';
import '../../domain/entities/localized_book.dart';
import '../../domain/repositories/bible_book_repository.dart';
import '../datasources/drift_book_local_datasource_impl.dart';

class BibleBookRepositoryImpl implements BibleBookRepository {
  final BibleBookLocalDataSource _localDataSource;

  BibleBookRepositoryImpl(this._localDataSource);

  @override
  Future<List<LocalizedBook>> getBooksForBibleTranslation(
    BibleId bibleId,
  ) async {
    final dtos = await _localDataSource.getBooksForBible(bibleId.externalId);
    return dtos
        .map((dto) => LocalizedBook(
              book: _parseBookToken(dto.bookToken),
              longName: dto.longName,
              shortName: dto.shortName,
              abbreviation: dto.abbr,
            ))
        .toList();
  }

  @override
  Future<List<LocalizedBook>> searchBookByName(
      String query, int languageId) async {
    if (query.trim().isEmpty) return [];

    final dtos = await _localDataSource.searchBookByName(query, languageId);

    return dtos
        .map((dto) => LocalizedBook(
              book: _parseBookToken(dto.bookToken),
              longName: dto.longName,
              shortName: dto.shortName,
              abbreviation: dto.abbr,
            ))
        .toList();
  }

  BibleBook _parseBookToken(String token) {
    return BibleBook.values.firstWhere(
      (b) => b.name.toUpperCase() == token.toUpperCase(),
      orElse: () => throw FormatException('Unknown book token: $token'),
    );
  }
}
