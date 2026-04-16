import 'package:fpdart/fpdart.dart';

import '../../../../../shared/domain/entities/bible_meta.dart';
import '../../../../../shared/domain/entities/bible_ref.dart';
import '../../../../../shared/domain/entities/verse_segment.dart';
import '../../../../../shared/error/failure.dart';

abstract class BibleRepository {
  Future<Either<Failure, BibleMeta>> getBibleMetadata({
    required int bibleId,
  });

  Future<Either<Failure, List<VerseSegment>>> getVersesSegmentsWithSpans({
    required int bibleId,
    required List<BibleRef> refs,
  });

  Future<Either<Failure, List<VerseSegment>>> getChapterSegments({
    required int bibleId,
    required BibleRef reference,
  });

  Future<Either<Failure, List<VerseSegment>>> getChapterWithSpans({
    required int bibleId,
    required BibleRef reference,
  });

  Future<Either<Failure, int>> getMaxVerse({
    required int bibleId,
    required BibleRef reference,
  });
}
