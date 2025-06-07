import 'package:fpdart/fpdart.dart';

import '../../../../core/domain/entities/e_bible.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/data/datasources/bible_remote_datasource.dart';
import '../../domain/entities/bible_download_progress.dart';
import '../../domain/repositories/bible_manager_repository.dart';
import '../../../../core/data/datasources/bible_local_datasource.dart';

// ignore_for_file: constant_identifier_names

class TranslationManagerRepositoryImpl implements BibleManagerRepository {
  final BibleLocalDataSource localDataSource;
  final BibleRemoteDataSource remoteDataSource;

  const TranslationManagerRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<EBible>>> getAllDownloadableBibles() async {
    var resultModels = await remoteDataSource.getListOfAllBibles();
    var resultEntities = resultModels.map((m) => m.toDomain()).toList();
    return Right(resultEntities);
  }

  @override
  Future<Either<Failure, List<EBible>>> getAllInstalledBibles() async {
    var resultModels = await localDataSource.getInstalledBibles();
    var resultEntities = resultModels.map((m) => m.toDomain()).toList();
    return Right(resultEntities);
  }

  @override
  Future<Either<Failure, Stream<DownloadProgess>>> downloadTranslation(
    String bibleId,
  ) async {
    return Right(remoteDataSource.downloadBibleFileContent(bibleId));
  }

  @override
  Future<Either<Failure, void>> installTranslation(String bibleId) async {
    return Right(await localDataSource.installBible(bibleId));
  }

  @override
  Future uninstallTranslation(String bibleId) async {
    await localDataSource.uninstallBible(bibleId);
  }
}
