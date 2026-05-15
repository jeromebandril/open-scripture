import 'package:open_scripture/features/bible_installer_manager/domain/entities/bible_download_progress.dart';

abstract class BibleImporterRepo {
  Stream<InstallProgress> importAndInstallFromPath(
    String path, {
    required String displayName,
  });
}
