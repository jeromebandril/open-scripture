import 'package:fpdart/fpdart.dart';

import '../../../../../core/domain/entities/e_verse.dart';
import '../../../../../core/error/failure.dart';
import '../../../../b_searchbar/domain/entities/bible_reference.dart';

abstract class ReaderRepository {
  // Future<Either<Failure, Translation>> openTranslation(String id);
  // Future<Either<Failure, void>> removeTranslation(String id);
  Future<Either<Failure, List<EVerse>>> getVerses(BibleReference reference);
  // Future<Either<Failure, Translation>> getTranslation(String id);
}
