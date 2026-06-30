import 'package:fpdart/fpdart.dart';

import '../../../../../shared/domain/entities/bible_ref_partial.dart';
import '../../../../../shared/error/failure.dart';
import '../../../../../shared/utils/bible_ref_parser/bible_ref_parser.dart';
import '../../../../../shared/utils/bible_ref_parser/bible_ref_parser_exceptions.dart';
import '../../domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final BibleRefParser _parser;

  const SearchRepositoryImpl({
    required BibleRefParser parser,
  }) : _parser = parser;

  @override
  Future<Either<Failure, BibleRefPartial>> parse(String query) async {
    try {
      final ref = await _parser.parse(query);
      return Right(ref);
    } on BibleRefInvalidFormatException catch (e) {
      return Left(InvalidInputFailure(details: e.message));
    } on BibleRefInvalidNumberException catch (e) {
      return Left(InvalidInputFailure(details: e.message));
    } on BibleRefOutOfRangeException catch (e) {
      return Left(InvalidInputFailure(details: e.message));
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
