import 'dart:async';
import 'dart:math';
import 'package:fpdart/fpdart.dart';
import 'package:open_scripture/features/bible_installer_manager/domain/entities/bible_download_progress.dart';
import 'package:open_scripture/features/bible_installer_manager/domain/repositories/bible_manager_repository.dart';
import 'package:open_scripture/core/engines/bible_compiler/domain/models/artifact.dart';
import 'package:open_scripture/core/infrastructure/bible_data/install/bible_install_datasource.dart';
import 'package:open_scripture/features/bible_installer_manager/data/datasource/bible_download_datasource.dart';
import 'package:open_scripture/shared/entities/bible_meta.dart';
import 'package:open_scripture/shared/error/failure.dart';

class BibleManagerRepositoryImpl implements BibleManagerRepository {
  const BibleManagerRepositoryImpl({
    required BibleInstallDatasource installDatasource,
    required BibleDownloadDatasource downloadDatasource,
  })  : _installDatasource = installDatasource,
        _downloadDatasource = downloadDatasource;

  final BibleInstallDatasource _installDatasource;
  final BibleDownloadDatasource _downloadDatasource;

  @override
  Future<Either<Failure, List<BibleMeta>>> getDownloadCatalog() async {
    final result = await _downloadDatasource.getDownloadCatalog();
    return Right(result);
  }

  @override
  Stream<InstallProgress> downloadAndInstallBible(String bibleId) async* {
    // uncomment for UI tests
    //return _simulateDownloadAndInstall();

    Artifact? artifact;

    // 1) Download phase
    await for (final p
        in _downloadDatasource.downloadBibleFileContent(bibleId)) {
      yield p;

      if (p.stage == InstallStage.failed) return;

      if (p.stage == InstallStage.downloadingDone) {
        artifact = p.artifact;
        break;
      }
    }

    if (artifact == null) {
      yield const InstallProgress(
        stage: InstallStage.failed,
        message: 'Download completed but no artifact was produced.',
      );
      return;
    }

    // 2) Install phase
    await for (final p in _installDatasource.installBible(artifact)) {
      yield p;
      if (p.stage == InstallStage.failed) return;
      if (p.stage == InstallStage.done) return;
    }

    yield const InstallProgress(stage: InstallStage.done);
  }

  @override
  Future<Either<Failure, void>> uninstallBible(String bibleId) async {
    try {
      return Right(await _installDatasource.uninstallBible(bibleId));
    } catch (e) {
      return Left(InstallFailure());
    }
  }

  /// Simulates data stream for progress bar UI tests
  Stream<InstallProgress> _simulateDownloadAndInstall({
    Duration tick = const Duration(milliseconds: 80),
    int downloadBytesTotal = 50 * 1024 * 1024, // 50 MB
    int installStepsTotal = 60,
    double failChance = 0.0, // set to e.g. 0.05 for random failure
  }) async* {
    final rng = Random();

    // Download phase
    int received = 0;
    int total = downloadBytesTotal;

    yield InstallProgress(
      stage: InstallStage.downloading,
      received: received,
      total: total,
      message: 'Starting download...',
    );

    while (received < total) {
      await Future.delayed(tick);

      if (failChance > 0 && rng.nextDouble() < failChance) {
        yield const InstallProgress(
          stage: InstallStage.failed,
          message: 'Simulated network failure',
        );
        return;
      }

      final chunk = max(200000, total ~/ 80); // ~80 ticks minimum
      received = min(total, received + chunk);

      yield InstallProgress(
        stage: InstallStage.downloading,
        received: received,
        total: total,
        message: 'Downloading...',
      );
    }

    yield const InstallProgress(
      stage: InstallStage.downloadingDone,
      received: 1,
      total: 1,
      message: 'Download complete',
    );

    // Install phase
    yield const InstallProgress(
      stage: InstallStage.installing,
      received: 0,
      total: 0,
      message: 'Preparing install...',
    );

    for (int i = 1; i <= installStepsTotal; i++) {
      await Future.delayed(const Duration(milliseconds: 50));

      if (failChance > 0 && rng.nextDouble() < failChance) {
        yield const InstallProgress(
          stage: InstallStage.failed,
          message: 'Simulated install failure',
        );
        return;
      }

      yield InstallProgress(
        stage: InstallStage.installing,
        received: i,
        total: installStepsTotal,
        message: 'Installing... ($i/$installStepsTotal)',
      );
    }

    yield const InstallProgress(
      stage: InstallStage.done,
      received: 1,
      total: 1,
      message: 'Installed',
    );
  }
}
