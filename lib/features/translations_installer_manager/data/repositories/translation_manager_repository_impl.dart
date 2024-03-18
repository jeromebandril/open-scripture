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
  Stream<Either<Failure, List<int>>> downloadTranslation(
    String id,
  ) async* {
    TranslationInfoModel? downloadingTranslation;

    // update general list and retrive the translation info
    _tAllStreamController.value.fold((_) => null, (list) {
      final translationInfos = [...list];
      final index = translationInfos.indexWhere((t) => t.id == id);

      if (index == -1) {
        throw ServerException();
      } else {
        final t = translationInfos[index];
        downloadingTranslation = t;
        final newT = t.copyWith(
          downloadStatus: () => DownloadStatus.downloading,
        );
        translationInfos[index] = newT;

        _tAllStreamController.add(Right(translationInfos));
      }
    });

    // add translation to download queue and start download
    if (downloadingTranslation != null) {
      await for (var data in remoteDataSource.downloadTranslationFiles(id)) {
        yield Right(data);
      }
    }
  }

  @override
  Future<void> installTranslation(String path) async {
    await localDataSource.installTranslation(path);
  }

  @override
  Future uninstallTranslation(String path) {
    throw UnimplementedError();
  }
}
