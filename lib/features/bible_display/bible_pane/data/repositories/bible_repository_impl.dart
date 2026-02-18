import 'package:fpdart/fpdart.dart';

import '../../../../../shared/data/datasources/bible_sqllite_datasource.dart';
import '../../../../../shared/domain/entities/bible_meta.dart';
import '../../../../../shared/domain/entities/bible_ref.dart';
import '../../../../../shared/domain/entities/verse_segment.dart';
import '../../../../../shared/error/exception.dart';
import '../../../../../shared/error/failure.dart';
import '../../domain/repositories/bible_repository.dart';

class BibleRepositoryImpl implements BibleRepository {
  final BibleLocalDataSource localDatasource;

  const BibleRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Failure, List<VerseSegment>>> getVersesSegmentsWithSpans({
    required int bibleId,
    required List<BibleRef> refs,
  }) async {
    try {
      return Right(await localDatasource.getVersesSegments(bibleId, refs));
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
      final List<VerseSegment> verses = await localDatasource.getChapter(
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
      final verses = await localDatasource.getChapterWithSpans(
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
      return Right(await localDatasource.getBible(bibleId));
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
      final bookId = await localDatasource.resolveBookNameToId(
        bibleId,
        reference.bookUsfxId,
      );

      return Right(
          await localDatasource.getMaxVerseRange(bookId, reference.chapter));
    } catch (e) {
      return Left(UnexpectedFailure(details: e.toString()));
    }
  }
}
