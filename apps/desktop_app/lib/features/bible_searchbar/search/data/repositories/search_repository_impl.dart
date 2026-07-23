import 'package:fpdart/fpdart.dart';

import '../../../../../shared/domain/entities/bible_ref_partial.dart';
import '../../../../../shared/error/failure.dart';
import '../../../../../shared/utils/bible_ref_parser/bible_ref_parser.dart';
import '../../../../../shared/utils/bible_ref_parser/error/bible_ref_parser_exceptions.dart';
import '../../domain/error/search_failures.dart';
import '../../domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final BibleRefParser _parser;

  const SearchRepositoryImpl({
    required BibleRefParser parser,
  }) : _parser = parser;

  @override
  TaskEither<Failure, BibleRefPartial> parse(String query) {
    return TaskEither.tryCatch(
      () async => await _parser.parse(query),
      _mapToFailure,
    );
  }

  Failure _mapToFailure(Object error, StackTrace st) => switch (error) {
        BibleRefInvalidFormatException e =>
          InvalidInputFailure(cause: e, stackTrace: st),
        BibleRefOutOfRangeException e =>
          InvalidInputFailure(cause: e, stackTrace: st),
        _ => UnexpectedFailure(cause: error, stackTrace: st),
      };

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
