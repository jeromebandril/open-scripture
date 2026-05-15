import 'package:fpdart/fpdart.dart';
import 'package:open_scripture/core/infrastructure/bible_data/bible_local_datasource.dart';

import 'package:open_scripture/shared/entities/book.dart';

import 'package:open_scripture/shared/error/failure.dart';

import '../../domain/repository/three_tap_navigator_repository.dart';

class ThreeTapNavigatorRepositoryImpl implements ThreeTapNavigatorRepository {
  final BibleLocalDataSource localDataSource;

  ThreeTapNavigatorRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Book>>> getBooks({required int bibleId}) async {
    try {
      return Right(await localDataSource.getBooks(bibleId));
    } catch (e) {
      return Left(UnknownFailure(details: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getMaxChapter({required int bookId}) async {
    try {
      return Right(await localDataSource.getMaxChapter(bookId));
    } catch (e) {
      return Left(UnknownFailure(details: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getMaxVerse(
      {required int bookId, required int chapter}) async {
    try {
      return Right(await localDataSource.getMaxVerseRange(bookId, chapter));
    } catch (e) {
      return Left(UnknownFailure(details: e.toString()));
    }
  }
}
