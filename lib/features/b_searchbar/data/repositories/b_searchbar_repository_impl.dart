import 'package:fpdart/fpdart.dart';
import 'package:the_smyrna_bible_v2/core/error/failure.dart';
import 'package:the_smyrna_bible_v2/core/utils/bible_ref_parser/bible_ref_parser.dart';
import 'package:the_smyrna_bible_v2/features/b_searchbar/domain/repositories/b_searchbar_repository.dart';

import '../../../../core/domain/entities/bible_ref.dart';
import '../../../../core/utils/bible_ref_parser/bible_ref_parser_exceptions.dart';

class BSearchbarRepositoryImpl implements BSearchbarRepository {
  final BibleReferenceParser parser;

  const BSearchbarRepositoryImpl({required this.parser});

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
}
