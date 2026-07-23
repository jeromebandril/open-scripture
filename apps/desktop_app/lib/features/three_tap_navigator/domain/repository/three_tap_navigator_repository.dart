import 'package:fpdart/fpdart.dart';
import '../../../../shared/domain/entities/bible_id.dart';
import '../../../../shared/domain/entities/localized_book.dart';
import '../../../../shared/error/failure.dart';

// TODO: should not use bookToken, instead use BibleBook

abstract class ThreeTapNavigatorRepository {
  TaskEither<Failure, List<LocalizedBook>> getBooks({
    required BibleId bibleId,
  });

  TaskEither<Failure, int> getChapterBoundaryOf({
    required String bookToken,
  });

  TaskEither<Failure, int> getVerseBoundaryOf({
    required String bookToken,
    required int chapter,
  });
}
