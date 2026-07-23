import 'package:fpdart/fpdart.dart';

import '../../../../shared/data/datasources/bible_content_datasource/bible_content_datasourcee.dart';
import '../../../../shared/data/datasources/drift_book_local_datasource_impl.dart';
import '../../../../shared/data/models/book_dto.dart';
import '../../../../shared/domain/entities/bible_id.dart';
import '../../../../shared/domain/entities/localized_book.dart';
import '../../../../shared/error/failure.dart';
import '../../domain/repository/three_tap_navigator_repository.dart';

class ThreeTapNavigatorRepositoryImpl implements ThreeTapNavigatorRepository {
  // TODO: I should conditionally inject here a different implementation based on repo type
  // maybe a factory as in bible_pane. But there the repository swap happend in the
  // presentation/state level. Here I should do a datasource swap. The latter seems the most logical
  // so maybe I will refactor bible_pane to do the same.
  //
  // The current problem is that even when getBooks throws or return empty list,
  // the default book list doesn't get the correct chapter/verse boundaries
  // because it tries to fetch it from the sqlite db (the implementation is constant and injected in DI)
  //
  // As a workaround I will use the enum `BookLoadType.defaulted` to know when to pass a fixed constant value
  final BibleContentDatasource _contentDataSource;
  final BibleBookLocalDataSource _booksDataSource;

  ThreeTapNavigatorRepositoryImpl({
    required BibleContentDatasource contentDataSource,
    required BibleBookLocalDataSource booksLocalDataSource,
  })  : _booksDataSource = booksLocalDataSource,
        _contentDataSource = contentDataSource;

  @override
  TaskEither<Failure, List<LocalizedBook>> getBooks({
    required BibleId bibleId,
  }) {
    return TaskEither.tryCatch(() async {
      final dtos = await _booksDataSource.getBooksForBible(bibleId.externalId);
      return dtos.map((dto) => dto.toDomain()).toList();
    },
        (error, st) => switch (error) {
              _ => UnexpectedFailure(cause: error, stackTrace: st),
            });
  }

  @override
  TaskEither<Failure, int> getChapterBoundaryOf({
    required String bookToken,
  }) {
    return TaskEither.tryCatch(
        () async => await _contentDataSource.getChapterBoundaryOf(
              bookToken: bookToken,
            ),
        (error, st) => switch (error) {
              _ => UnexpectedFailure(cause: error, stackTrace: st),
            });
  }

  @override
  TaskEither<Failure, int> getVerseBoundaryOf({
    required String bookToken,
    required int chapter,
  }) {
    return TaskEither.tryCatch(
        () async => await _contentDataSource.getVerseBoundaryOf(
              bookToken: bookToken,
              chapter: chapter,
            ),
        (error, st) => switch (error) {
              _ => UnexpectedFailure(cause: error, stackTrace: st),
            });
  }
}
