import 'package:fpdart/fpdart.dart';

import '../../../../../core/domain/entities/bible_ref.dart';
import '../../../../../core/domain/entities/verse_segment.dart';
import '../../../../../core/error/failure.dart';

abstract class BibleRepository {
  // Future<Either<Failure, Translation>> openTranslation(String id);
  // Future<Either<Failure, void>> removeTranslation(String id);
  Future<Either<Failure, List<VerseSegment>>> getChapterSegments({
    required int bibleId,
    required BibleRef reference,
  });

  Future<Either<Failure, List<VerseSegment>>> getVersesSegments({
    required int bibleId,
    required BibleRef reference,
  });
  // Future<Either<Failure, Translation>> getTranslation(String id);
}
