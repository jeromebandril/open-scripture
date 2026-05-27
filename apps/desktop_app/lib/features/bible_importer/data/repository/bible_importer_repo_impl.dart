import 'package:open_scripture/core/infrastructure/bible_data/install/bible_install_datasource.dart';
import 'package:open_scripture/features/bible_installer_manager/domain/entities/bible_download_progress.dart';
import 'package:open_scripture/core/engines/bible_compiler/domain/models/artifact.dart';

import '../../domain/repository/bible_importer_repo.dart';

class BibleImporterRepoImpl implements BibleImporterRepo {
  final BibleInstallDatasource _datasource;

  const BibleImporterRepoImpl({required BibleInstallDatasource localDataSource})
      : _datasource = localDataSource;

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

    await for (final p in _datasource.installBible(artifact)) {
      yield p;
      if (p.stage == InstallStage.failed) return;
      if (p.stage == InstallStage.done) return;
    }

    yield const InstallProgress(stage: InstallStage.done);
  }
}
