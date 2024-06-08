import 'package:rxdart/rxdart.dart';
import 'package:the_smyrna_bible_v2/core/error/exception.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/models/translation_manager_model.dart';
import '../../domain/entities/translation_info.dart';
import '../datasources/translation_manager_remote_datasource.dart';
import '../../domain/repositories/translation_manager_repository.dart';
import '../datasources/translation_manager_local_datasource.dart';
import '../models/translation_info_model.dart';

// ignore_for_file: constant_identifier_names

const MAX_QUEUE = 4;

class TranslationManagerRepositoryImpl implements TranslationManagerRepository {
  // When processing a download, a translationInfo will move
  // in order in these streams:
  // 1. All translations overview (not yet interacted with)
  // 2. Download queue overview (when prompt to download)
  // 3. Installed translations overview (after download finishes)
  final BehaviorSubject<Either<Failure, List<TranslationInfoModel>>>
      _tAllStreamController = BehaviorSubject.seeded(const Right([]));

  final BehaviorSubject<Either<Failure, List<TranslationInfoModel>>>
      _tInstalledStreamController = BehaviorSubject.seeded(const Right([]));

  final downloadQueue = List<TranslationInfo>.empty();
  final TranslationManagerLocalDataSource localDataSource;
  final TranslationManagerRemoteDataSource remoteDataSource;
  final TranslationManagerModel manager;

  TranslationManagerRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.manager,
  }) {
    _init();
  }

  void _init() async {
    // get the list of available to download translation
    // from remote datasource
    try {
      final list = await remoteDataSource.getAllTranslationsInfos();
      _tAllStreamController.add(Right(list));
    } on ServerException {
      _tAllStreamController.add(const Left(ServerFailure()));
    }
    // get the list of already installed trnaslations
    // from local datasource
    try {
      final installedList = await localDataSource.getInstalledTransationInfos();
      _tInstalledStreamController.add(Right(installedList));
    } on NoLocalDataException {
      _tInstalledStreamController.add(const Left(NoLocalDataFailure()));
    }
  }

  @override
  Stream<Either<Failure, List<TranslationInfoModel>>> getAllTranslationsList() {
    return _tAllStreamController.asBroadcastStream();
  }

  @override
  Stream<Either<Failure, List<TranslationInfoModel>>>
      getInstalledTranslationList() {
    return _tInstalledStreamController.asBroadcastStream();
  }

  @override
  Future<Either<Failure, Stream<List<int>>>> downloadTranslation(
    String id,
  ) async {
    return Right(remoteDataSource.downloadTranslationFiles(id));
  }

  @override
  Future<void> installTranslation(String id) async {
    await localDataSource.installTranslation(id);
  }

  @override
  Future uninstallTranslation(String path) {
    throw UnimplementedError();
  }
}
