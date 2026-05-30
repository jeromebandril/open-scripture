import 'package:fpdart/fpdart.dart';
import 'package:open_scripture/shared/domain/entities/bible_ref.dart';
import 'package:open_scripture/shared/domain/services/bible_ref_parser.dart';
import 'package:open_scripture/shared/error/failure.dart';
import 'package:open_scripture/features/bible_searchbar/search/domain/repositories/search_repository.dart';
import 'package:open_scripture/shared/utils/bible_ref_parser/bible_ref_parser_exceptions.dart';

class SearchRepositoryImpl implements SearchRepository {
  final BibleRefParser _parser;

  const SearchRepositoryImpl({
    required BibleRefParser parser,
  }) : _parser = parser;

  @override
  Future<Either<Failure, BibleRef>> parse(String query) async {
    try {
      final ref = await _parser.parse(query);
      return Right(ref);
    } on BibleRefInvalidFormatException catch (e) {
      return Left(InvalidInputFailure(details: e.message));
    } on BibleRefUnknownBookException catch (e) {
      return Left(InvalidInputFailure(details: e.message));
    } on BibleRefInvalidNumberException catch (e) {
      return Left(InvalidInputFailure(details: e.message));
    } on BibleRefOutOfRangeException catch (e) {
      return Left(InvalidInputFailure(details: e.message));
    } on BibleRefAmbiguousBookException catch (e) {
      return Left(InvalidInputFailure(
          details:
              '${e.message} Possible candidates: ${e.candidates.join(', ')}'));
    } catch (e) {
      return Left(UnknownFailure(details: e.toString()));
    }
  }

  // String _ftsPhrase(String input) {
  //   final trimmed = input.trim(); // Escape quotes for FTS
  //   final escaped = trimmed.replaceAll('"', '""');
  //   return '"$escaped"';
  // }

  // @override
  // Future<Either<Failure, List<BibleRef>>> find({
  //   required List<int> bibleIds,
  //   required String match,
  // }) async {
  //   try {
  //     return Right(
  //         await localDataSource.searchVerses(bibleIds, _ftsPhrase(match)));
  //   } catch (e) {
  //     return Left(UnknownFailure(details: e.toString()));
  //   }
  // }
}
