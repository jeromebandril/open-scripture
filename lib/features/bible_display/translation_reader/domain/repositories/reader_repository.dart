import 'package:fpdart/fpdart.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/domain/entities/page.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/domain/entities/translation.dart';
import '../../../../../core/domain/entities/bible_reference.dart';

abstract class ReaderRepository {
  Future<Either<Failure, Translation>> openTranslation(String id);
  // Future<Either<Failure, void>> removeTranslation(String id);
  Future<Either<Failure, PageContent>> getChapter(BibleRef reference);
  Future<Either<Failure, Translation>> getTranslation(String id);
}
