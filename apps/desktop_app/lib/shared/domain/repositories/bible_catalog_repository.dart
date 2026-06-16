import 'package:fpdart/fpdart.dart';
import 'package:open_scripture/shared/domain/entities/bible_id.dart';
import 'package:open_scripture/shared/domain/entities/bible_translation.dart';
import 'package:open_scripture/shared/error/failure.dart';

abstract class BibleCatalogRepository {
  Future<Either<Failure, List<BibleTranslation>>> getAvailableBibles();
  Future<Either<Failure, BibleTranslation>> getBibleDetails(BibleId bibleId);
}
