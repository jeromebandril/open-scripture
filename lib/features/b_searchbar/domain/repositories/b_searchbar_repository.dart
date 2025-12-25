import 'package:fpdart/fpdart.dart';
import 'package:the_smyrna_bible_v2/core/error/failure.dart';

import '../../../../core/domain/entities/bible_ref.dart';

abstract class BSearchbarRepository {
  Future<Either<Failure, BibleRef>> getParseIntent(String query);
}
