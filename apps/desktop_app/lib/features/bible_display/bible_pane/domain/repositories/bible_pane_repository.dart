import 'package:fpdart/fpdart.dart';

import '../../../../../shared/entities/bible_meta.dart';
import '../../../../../shared/entities/bible_ref.dart';
import '../../../../../shared/entities/verse_segment.dart';
import '../../../../../shared/error/failure.dart';

abstract class BiblePaneRepository {
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
