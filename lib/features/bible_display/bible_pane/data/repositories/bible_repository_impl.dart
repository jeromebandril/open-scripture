import 'package:fpdart/fpdart.dart';

import '../../../../../core/data/datasources/bible_sqllite_datasource.dart';
import '../../../../../core/domain/entities/bible_meta.dart';
import '../../../../../core/domain/entities/bible_ref.dart';
import '../../../../../core/domain/entities/verse_segment.dart';
import '../../../../../core/error/exception.dart';
import '../../../../../core/error/failure.dart';
import '../../domain/repositories/bible_repository.dart';

class BibleRepositoryImpl implements BibleRepository {
  final BibleLocalDataSource localDatasource;

  const BibleRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Failure, List<VerseSegment>>> getVersesSegments({
    required int bibleId,
    required BibleRef reference,
  }) async {
    // TODO: implement getVerse
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<VerseSegment>>> getChapterSegments({
    required int bibleId,
    required BibleRef reference,
  }) async {
    try {
      final List<VerseSegment> verses = await localDatasource.getChapter(
          bibleId, reference.bookOsisId, reference.chapter);
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
          bibleId, reference.bookOsisId, reference.chapter);
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
}
