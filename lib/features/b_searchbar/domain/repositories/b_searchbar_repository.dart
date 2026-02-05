import 'package:fpdart/fpdart.dart';
import 'package:open_scripture/core/error/failure.dart';

import '../../../../core/domain/entities/bible_ref.dart';

abstract class BSearchbarRepository {
  Future<Either<Failure, BibleRef>> getParseIntent(String query);

  Future<Either<Failure, List<BibleRef>>> find({
    required int bibleId,
    required String match,
  });
}
