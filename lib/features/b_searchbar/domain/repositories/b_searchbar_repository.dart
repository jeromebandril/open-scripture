import 'package:fpdart/fpdart.dart';
import 'package:open_scripture/shared/error/failure.dart';

import '../../../../shared/domain/entities/bible_ref.dart';

abstract class BSearchbarRepository {
  Future<Either<Failure, BibleRef>> getParseIntent(String query);

  Future<Either<Failure, List<BibleRef>>> find({
    required List<int> bibleIds,
    required String match,
  });
}
