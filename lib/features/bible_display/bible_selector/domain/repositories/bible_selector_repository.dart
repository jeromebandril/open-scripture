import 'package:fpdart/fpdart.dart';

import '../../../../../core/domain/entities/bible_meta.dart';
import '../../../../../core/error/failure.dart';

abstract class BibleSelectorRepository {
  Future<Either<Failure, List<BibleMeta>>> getInstalledBibles();
}
