import 'package:fpdart/fpdart.dart';

import '../../../../../core/data/datasources/bible_local_datasource.dart';
import '../../../../../core/data/models/verse_model.dart';
import '../../../../../core/domain/entities/e_verse.dart';
import '../../../../../core/error/failure.dart';
import '../../../../b_searchbar/domain/entities/bible_reference.dart';
import '../../domain/repositories/reader_repository.dart';

class ReaderRepositoryImpl implements ReaderRepository {
  final BibleLocalDataSource localDatasource;

  const ReaderRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Failure, List<EVerse>>> getVerses(
      BibleReference reference) async {
    try {
      final List<VerseModel> verseModels =
          await localDatasource.getVerseRange('', '', 1, 1);
      final List<EVerse> verseEntities =
          verseModels.map((m) => m.toDomain()).toList();

      return Right(verseEntities);
    } catch (e) {
      return Left(NotFoundFailure());
    }
  }
}
