import 'package:fpdart/fpdart.dart';

import '../../../../shared/data/datasources/bible_content_datasource/bible_content_datasourcee.dart';
import '../../../../shared/data/datasources/drift_book_local_datasource_impl.dart';
import '../../../../shared/data/models/book_dto.dart';
import '../../../../shared/domain/entities/bible_id.dart';
import '../../../../shared/domain/entities/localized_book.dart';
import '../../../../shared/error/failure.dart';
import '../../domain/repository/three_tap_navigator_repository.dart';

class ThreeTapNavigatorRepositoryImpl implements ThreeTapNavigatorRepository {
  final BibleContentDatasource _contentDataSource;
  final BibleBookLocalDataSource _booksLocalDataSource;

  ThreeTapNavigatorRepositoryImpl({
    required BibleContentDatasource contentDataSource,
    required BibleBookLocalDataSource booksLocalDataSource,
  })  : _booksLocalDataSource = booksLocalDataSource,
        _contentDataSource = contentDataSource;

  @override
  Future<Either<Failure, List<LocalizedBook>>> getBooks({
    required BibleId bibleId,
  }) async {
    try {
      final dtos =
          await _booksLocalDataSource.getBooksForBible(bibleId.externalId);
      final books = dtos.map((dto) => dto.toDomain()).toList();
      return Right(books);
    } catch (e) {
      return Left(UnknownFailure(details: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getChapterBoundaryOf({
    required String bookToken,
  }) async {
    try {
      return Right(await _contentDataSource.getChapterBoundaryOf(
        bookToken: bookToken,
      ));
    } catch (e) {
      return Left(UnknownFailure(details: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getVerseBoundaryOf({
    required String bookToken,
    required int chapter,
  }) async {
    try {
      return Right(await _contentDataSource.getVerseBoundaryOf(
        bookToken: bookToken,
        chapter: chapter,
      ));
    } catch (e) {
      return Left(UnknownFailure(details: e.toString()));
    }
  }
}
