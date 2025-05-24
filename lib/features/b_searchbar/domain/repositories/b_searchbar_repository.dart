import 'package:fpdart/fpdart.dart';
import 'package:the_smyrna_bible_v2/core/error/failure.dart';
import 'package:the_smyrna_bible_v2/features/b_searchbar/domain/entities/bible_reference.dart';

abstract class BSearchbarRepository {
  Future<Either<Failure, BibleReference>> getBibleReference(String query);
}
