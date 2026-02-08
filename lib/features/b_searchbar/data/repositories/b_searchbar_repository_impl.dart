import 'package:fpdart/fpdart.dart';
import 'package:open_scripture/shared/data/datasources/bible_sqllite_datasource.dart';
import 'package:open_scripture/shared/error/failure.dart';
import 'package:open_scripture/shared/utils/bible_ref_parser/bible_ref_parser.dart';
import 'package:open_scripture/features/b_searchbar/domain/repositories/b_searchbar_repository.dart';

import '../../../../shared/domain/entities/bible_ref.dart';
import '../../../../shared/utils/bible_ref_parser/bible_ref_parser_exceptions.dart';

class BSearchbarRepositoryImpl implements BSearchbarRepository {
  final BibleReferenceParser parser;
  final BibleLocalDataSource localDataSource;

  const BSearchbarRepositoryImpl({
    required this.parser,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, BibleRef>> getParseIntent(String query) async {
    try {
      return Right(parser.analyze(query));
    } on BibleRefInvalidFormatException catch (e) {
      return Left(InvalidInputFailure(details: e.message));
    } on BibleRefUnknownBookException catch (e) {
      return Left(InvalidInputFailure(details: e.message));
    } on BibleRefInvalidNumberException catch (e) {
      return Left(InvalidInputFailure(details: e.message));
    } on BibleRefOutOfRangeException catch (e) {
      return Left(InvalidInputFailure(details: e.message));
    } catch (e) {
      return Left(UnknownFailure(details: e.toString()));
    }
  }

  String _ftsPhrase(String input) {
    final trimmed = input.trim(); // Escape quotes for FTS
    final escaped = trimmed.replaceAll('"', '""');
    return '"$escaped"';
  }

  @override
  Future<Either<Failure, List<BibleRef>>> find({
    required int bibleId,
    required String match,
  }) async {
    try {
      return Right(
          await localDataSource.searchVerses(bibleId, _ftsPhrase(match)));
    } catch (e) {
      return Left(UnknownFailure(details: e.toString()));
    }
  }
}
