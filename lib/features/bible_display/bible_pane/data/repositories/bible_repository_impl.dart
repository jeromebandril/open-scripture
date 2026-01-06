import 'package:fpdart/fpdart.dart';

import '../../../../../core/data/datasources/bible_sqllite_datasource.dart';
import '../../../../../core/domain/entities/bible_ref.dart';
import '../../../../../core/domain/entities/verse_segment.dart';
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
    // try {
    //   final List<VerseSegment> verses =
    //       await localDatasource.getVerseFromRange('', '', 1, 1);

    //   return Right(verses);
    // } catch (e) {
    //   return Left(NotFoundFailure());
    // }
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
    } catch (e) {
      return Left(NotFoundFailure());
    }
  }
}
