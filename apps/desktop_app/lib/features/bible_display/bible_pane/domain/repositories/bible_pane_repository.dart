import 'package:fpdart/fpdart.dart';
import '../../../../../shared/domain/entities/bible_id.dart';
import '../../../../../shared/domain/entities/bible_ref.dart';
import '../../../../../shared/domain/entities/bible_translation.dart';
import '../../../../../shared/domain/entities/verse.dart';
import '../../../../../shared/error/failure.dart';

abstract class BiblePaneRepository {
  TaskEither<Failure, BibleTranslation> getBible({
    required BibleId bibleId,
  });

  TaskEither<Failure, List<Verse>> getVerses({
    required BibleId bibleId,
    required List<BibleRef> refs,
  });

  TaskEither<Failure, List<Verse>> getChapter({
    required BibleId bibleId,
    required BibleRef ref,
  });
}
