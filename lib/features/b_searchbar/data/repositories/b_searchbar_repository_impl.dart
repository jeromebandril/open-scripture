import 'package:fpdart/fpdart.dart';
import 'package:the_smyrna_bible_v2/core/error/failure.dart';
import 'package:the_smyrna_bible_v2/core/utils/bible_reference_parser.dart';
import 'package:the_smyrna_bible_v2/features/b_searchbar/domain/repositories/b_searchbar_repository.dart';

import '../../../../core/domain/entities/bible_ref.dart';

class BSearchbarRepositoryImpl implements BSearchbarRepository {
  final BibleReferenceParser parser;

  const BSearchbarRepositoryImpl({required this.parser});

  @override
  Future<Either<Failure, BibleRef>> getParseIntent(String query) async {
    try {
      return Right(await parser.analyze(query));
    } catch (e) {
      return Left(InvalidInputFailure());
    }
  }
}
