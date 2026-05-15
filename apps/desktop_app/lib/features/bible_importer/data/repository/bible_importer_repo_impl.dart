import 'package:open_scripture/features/bible_installer_manager/domain/entities/bible_download_progress.dart';
import 'package:open_scripture/core/infrastructure/bible_data/bible_local_datasource.dart';
import 'package:open_scripture/core/systems/installer/bible/domain/models/artifact.dart';

import '../../domain/repository/bible_importer_repo.dart';

class BibleImporterRepoImpl implements BibleImporterRepo {
  final BibleLocalDataSource localDataSource;

  const BibleImporterRepoImpl({required this.localDataSource});

  @override
  Stream<InstallProgress> importAndInstallFromPath(
    String path, {
    required String displayName,
  }) async* {
    yield const InstallProgress(
      stage: InstallStage.installing,
      message: 'Preparing...',
    );
    final artifact = Artifact(path: path, displayName: displayName);

    await for (final p in localDataSource.installBible(artifact)) {
      yield p;
      if (p.stage == InstallStage.failed) return;
      if (p.stage == InstallStage.done) return;
    }

    yield const InstallProgress(stage: InstallStage.done);
  }
}
