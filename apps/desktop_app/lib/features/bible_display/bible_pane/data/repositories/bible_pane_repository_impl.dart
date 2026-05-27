import 'package:fpdart/fpdart.dart';
import 'package:open_scripture/core/infrastructure/bible_data/content/bible_content_datasource.dart';
import 'package:open_scripture/features/my_library/data/datasources/my_library_datasource.dart';

import '../../../../../shared/entities/bible_meta.dart';
import '../../../../../shared/entities/bible_ref.dart';
import '../../../../../shared/entities/verse_segment.dart';
import '../../../../../shared/error/exception.dart';
import '../../../../../shared/error/failure.dart';
import '../../domain/repositories/bible_pane_repository.dart';

class BiblePaneRepositoryImpl implements BiblePaneRepository {
  const BiblePaneRepositoryImpl({
    required BibleContentDatasource localDatasource,
    required MyLibraryDatasource libraryDatasource,
  })  : _contentDatasource = localDatasource,
        _libraryDatasource = libraryDatasource;

  final BibleContentDatasource _contentDatasource;
  final MyLibraryDatasource _libraryDatasource;

  @override
  Future<Either<Failure, List<VerseSegment>>> getVersesSegmentsWithSpans({
    required int bibleId,
    required List<BibleRef> refs,
  }) async {
    try {
      return Right(await _contentDatasource.getVersesSegments(bibleId, refs));
    } catch (e) {
      return Left(UnknownFailure(details: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VerseSegment>>> getChapterSegments({
    required int bibleId,
    required BibleRef reference,
  }) async {
    try {
      final List<VerseSegment> verses = await _contentDatasource.getChapter(
          bibleId, reference.bookUsfxId, reference.chapter);
      return Right(verses);
    } on NotFoundException catch (e) {
      return Left(
        ResourceNotFoundFailure(details: e.message),
      );
    } on LocalDataException catch (e) {
      return Left(
        DatabaseFailure(details: e.message),
      );
    } on AppException catch (e) {
      // Catch-all for future domain exceptions
      return Left(
        UnknownFailure(details: e.message),
      );
    } catch (e, st) {
      return Left(
        UnexpectedFailure(
          details: e.toString(),
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<VerseSegment>>> getChapterWithSpans({
    required int bibleId,
    required BibleRef reference,
  }) async {
    try {
      final verses = await _contentDatasource.getChapterWithSpans(
          bibleId, reference.bookUsfxId, reference.chapter);
      return Right(verses);
    } on NotFoundException catch (e) {
      return Left(
        ResourceNotFoundFailure(details: e.message),
      );
    } on LocalDataException catch (e) {
      return Left(
        DatabaseFailure(details: e.message),
      );
    } on AppException catch (e) {
      // Catch-all for future domain exceptions
      return Left(
        UnknownFailure(details: e.message),
      );
    } catch (e, st) {
      return Left(
        UnexpectedFailure(
          details: e.toString(),
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, BibleMeta>> getBibleMetadata(
      {required int bibleId}) async {
    try {
      return Right(await _libraryDatasource.getBible(bibleId));
    } catch (e) {
      return Left(NoLocalDataFailure());
    }
  }

  @override
  Future<Either<Failure, int>> getMaxVerse({
    required int bibleId,
    required BibleRef reference,
  }) async {
    try {
      final bookId = await _contentDatasource.resolveBookNameToId(
        bibleId,
        reference.bookUsfxId,
      );

      return Right(
          await _contentDatasource.getMaxVerseRange(bookId, reference.chapter));
    } catch (e) {
      return Left(UnexpectedFailure(details: e.toString()));
    }
  }
}
