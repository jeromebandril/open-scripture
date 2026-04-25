import 'package:fpdart/fpdart.dart';

import '../../../../../shared/entities/bible_meta.dart';
import '../../../../../shared/error/failure.dart';

abstract class BibleSelectorRepository {
  Future<Either<Failure, List<BibleMeta>>> getInstalledBibles();
}
