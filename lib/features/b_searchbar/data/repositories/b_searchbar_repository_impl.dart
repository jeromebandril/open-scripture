import 'package:fpdart/fpdart.dart';
import 'package:the_smyrna_bible_v2/core/error/failure.dart';
import 'package:the_smyrna_bible_v2/core/utils/bible_reference_parser.dart';
import 'package:the_smyrna_bible_v2/features/b_searchbar/domain/entities/bible_reference.dart';
import 'package:the_smyrna_bible_v2/features/b_searchbar/domain/repositories/b_searchbar_repository.dart';

class BSearchbarRepositoryImpl implements BSearchbarRepository {
  final BibleReferenceParser parser;

  const BSearchbarRepositoryImpl({required this.parser});

  @override
  Future<Either<Failure, BibleReference>> getBibleReference(
      String query) async {
    return await parser.analyze(query);
  }
}
