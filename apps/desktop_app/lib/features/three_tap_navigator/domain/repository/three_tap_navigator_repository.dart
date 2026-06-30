import 'package:fpdart/fpdart.dart';
import '../../../../shared/domain/entities/bible_id.dart';
import '../../../../shared/domain/entities/localized_book.dart';
import '../../../../shared/error/failure.dart';

// TODO: should not use bookToken, instead use BibleBook

abstract class ThreeTapNavigatorRepository {
  Future<Either<Failure, List<LocalizedBook>>> getBooks({
    required BibleId bibleId,
  });

  Future<Either<Failure, int>> getChapterBoundaryOf({
    required String bookToken,
  });

  Future<Either<Failure, int>> getVerseBoundaryOf({
    required String bookToken,
    required int chapter,
  });
}
