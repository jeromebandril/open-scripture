import 'package:fpdart/fpdart.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/scripture_finder/domain/entity/bible_reference.dart';

import '../../../../../core/error/failure.dart';
import '../../../../translations_installer_manager/domain/entities/translation.dart';

abstract class ReaderRepository {
  Future<Either<Failure, Translation>> getTranslation(String id);
  Future<Either<Failure, void>> removeTranslation(String id);
  Future<Either<Failure, BibleReference>> getChapter(BibleReference reference);
}
