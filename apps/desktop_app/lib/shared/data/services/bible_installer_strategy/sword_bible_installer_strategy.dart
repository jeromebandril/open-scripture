import '../../../domain/entities/bible_download_progress.dart';
import '../../../domain/entities/bible_source.dart';
import '../../../domain/services/bible_importer_settings_service.dart';
import '../../../domain/services/bible_installer_strategy.dart';
import '../../datasources/bible_installation_datasource/sword_bible_installation_datasource_impl.dart';
import '../source_fetcher_service.dart';

class SwordInstallerStrategy implements BibleInstallerStrategy {
  final SourceFetcherService _fetcher;
  final SwordInstallationDatasource _localDatasource;
  final BibleImporterSettingsService _settingsService;

  SwordInstallerStrategy(
      {required SourceFetcherService fetcher,
      required SwordInstallationDatasource localDatasource,
      required BibleImporterSettingsService settingsService})
      : _localDatasource = localDatasource,
        _fetcher = fetcher,
        _settingsService = settingsService;

  @override
  Stream<InstallProgress> install(BibleSourceType source) async* {
    try {
      yield InstallProgress(
          stage: InstallStage.downloading,
          message: 'Fetching Sword package...');
      // 1. Resolve source to the same agnostic package
      final sourcePackage = await _fetcher.resolveSource(source);

      final basePath = _settingsService.current.swordInstallationPath;

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

    final basePath = _settingsService.current.swordInstallationPath;

    // Normalize the module ID (SWORD IDs are typically uppercase in code but lowercase in file systems)
    final String moduleCode = bibleId.toString().trim();

    await _localDatasource.deleteModuleFiles(
        moduleCode: moduleCode, basePath: basePath);
  }
}
