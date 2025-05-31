import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../datasources/bible_manager_remote_datasource.dart';
import '../../domain/repositories/translation_manager_repository.dart';
import '../datasources/bible_manager_local_datasource.dart';
import '../models/translation_info_model.dart';

// ignore_for_file: constant_identifier_names

class TranslationManagerRepositoryImpl implements TranslationManagerRepository {
  final BibleManagerLocalDataSource localDataSource;
  final bibleManagerRemoteDataSource remoteDataSource;

  const TranslationManagerRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<TranslationInfoModel>>>
      getAllTranslationsList() async {
    return Right(await remoteDataSource.getListOfAllBibles());
  }

  @override
  Future<Either<Failure, List<TranslationInfoModel>>>
      getInstalledTranslationList() async {
    return Right(await localDataSource.getInstalledTransationInfos());
  }

  @override
  Future<Either<Failure, Stream<List<int>>>> downloadTranslation(
    String id,
  ) async {
    return Right(remoteDataSource.downloadBibleFiles(id));
  }

  @override
  Future<void> installTranslation(String id) async {
    // Transform data and bring it into Sql lite database
    await localDataSource.installTranslation(id);
  }

  @override
  Future uninstallTranslation(String id) async {
    await localDataSource.uninstallTranslation(id);
  }
}
