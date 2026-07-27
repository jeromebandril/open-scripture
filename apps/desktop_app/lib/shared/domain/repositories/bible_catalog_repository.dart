import 'package:fpdart/fpdart.dart';

import '../../error/failure.dart';
import '../entities/bible_id.dart';
import '../entities/bible_translation.dart';

abstract class BibleCatalogRepository {
  TaskEither<Failure, List<BibleTranslation>> getAvailableBibles();
  TaskEither<Failure, BibleTranslation> getBibleDetails(BibleId bibleId);
}
