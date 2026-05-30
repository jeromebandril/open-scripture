import 'package:fpdart/fpdart.dart';
import 'package:open_scripture/shared/domain/entities/bible_book.dart';
import 'package:open_scripture/shared/domain/entities/bible_ref.dart';
import 'package:open_scripture/shared/domain/entities/bible_translation.dart';
import 'package:open_scripture/shared/domain/entities/verse.dart';
import 'package:open_scripture/shared/error/failure.dart';

abstract class BiblePaneRepository {
  Future<Either<Failure, BibleTranslation>> getBibleMetadata({
    required BibleId bibleId,
  });

  Future<Either<Failure, List<Verse>>> getVersesWithSpans({
    required BibleId bibleId,
    required List<BibleRef> refs,
  });

  Future<Either<Failure, List<Verse>>> getChapterWithSpans({
    required BibleId bibleId,
    required BibleRef ref,
  });

  Future<Either<Failure, List<Verse>>> getChapter({
    required BibleId bibleId,
    required BibleRef ref,
  });

  // TODO: passing BibleRef is enough, delete book parameter
  Future<Either<Failure, int>> getMaxVerse({
    required BibleBook book,
    required BibleRef ref,
  });
}
