import 'package:fpdart/fpdart.dart';

import '../../../../core/domain/entities/book.dart';
import '../../../../core/error/failure.dart';

abstract class ThreeTapNavigatorRepository {
  Future<Either<Failure, List<Book>>> getBooks({required int bibleId});

  Future<Either<Failure, int>> getMaxChapter({
    required int bookId,
  });

  Future<Either<Failure, int>> getMaxVerse({
    required int bookId,
    required int chapter,
  });
}
