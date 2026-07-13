import 'package:fpdart/fpdart.dart';

import '../../error/failure.dart';
import '../entities/bible_id.dart';
import '../entities/bible_translation.dart';

abstract class BibleCatalogRepository {
  Future<Either<Failure, List<BibleTranslation>>> getAvailableBibles();
  Future<Either<Failure, BibleTranslation>> getBibleDetails(BibleId bibleId);
}
