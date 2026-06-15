import 'package:open_scripture/core/engines/settings/settings_repository.dart';
import 'package:open_scripture/features/bible_importer/domain/entities/bible_importer_settings.dart';
import 'package:open_scripture/shared/data/datasources/bible_installation_datasource/sword_bible_installation_datasource_impl.dart';
import 'package:open_scripture/shared/data/services/source_fetcher_service.dart';
import 'package:open_scripture/shared/domain/entities/bible_download_progress.dart';
import 'package:open_scripture/shared/domain/entities/bible_source.dart';
import 'package:open_scripture/shared/domain/services/bible_installer_strategy.dart';

class SwordInstallerStrategy implements BibleInstallerStrategy {
  final SourceFetcherService _fetcher;
  final SettingsRepository<BibleImporterSettings> _settingsRepo;
  final SwordInstallationDatasource _localDatasource;

  SwordInstallerStrategy(
      {required SourceFetcherService fetcher,
      required SettingsRepository<BibleImporterSettings> settingsRepo,
      required SwordInstallationDatasource localDatasource})
      : _localDatasource = localDatasource,
        _fetcher = fetcher,
        _settingsRepo = settingsRepo;

  @override
  Stream<InstallProgress> install(BibleSourceType source) async* {
    try {
      yield InstallProgress(
          stage: InstallStage.downloading,
          message: 'Fetching Sword package...');
      // 1. Resolve source to the same agnostic package
      final sourcePackage = await _fetcher.resolveSource(source);

      // Fetch the path from settings
      final settingsResult = await _settingsRepo.loadSettings();
      final String basePath = settingsResult.fold(
        (failure) =>
            throw Exception('Could not resolve installation path settings.'),
        (settings) => settings.swordInstallationPath,
      );

      yield const InstallProgress(
          stage: InstallStage.installing,
          message: 'Extracting Sword module...');

      await _localDatasource.extractAndInstallModule(
        package: sourcePackage,
        targetBasePath: basePath,
      );

      yield const InstallProgress(
          stage: InstallStage.installing,
          message: 'Synchronizing Sword engine...');

      await _localDatasource.clearEngineCache(basePath: basePath);

      yield const InstallProgress(
          stage: InstallStage.done,
          message: 'Sword Module Installed Successfully!');
    } catch (e) {
      yield InstallProgress(stage: InstallStage.failed, message: e.toString());
    } finally {
      await _fetcher.cleanup(source);
    }
  }

  @override
  Future<void> uninstall(dynamic bibleId) async {
    if (bibleId is! String) {
      throw ArgumentError.value(bibleId, 'bibleId',
          'Expected a String, but received a ${bibleId.runtimeType}.');
    }

    // Resolve your platform-agnostic base directory path
    final settingsResult = await _settingsRepo.loadSettings();
    final String basePath = settingsResult.fold(
      (failure) => throw Exception(
          'Could not resolve installation path settings for uninstallation.'),
      (settings) => settings.swordInstallationPath,
    );

    // Normalize the module ID (SWORD IDs are typically uppercase in code but lowercase in file systems)
    final String moduleCode = bibleId.toString().trim();

    await _localDatasource.deleteModuleFiles(
        moduleCode: moduleCode, basePath: basePath);
  }
}
