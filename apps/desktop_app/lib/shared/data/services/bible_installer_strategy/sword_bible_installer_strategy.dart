import 'dart:io';

import 'package:open_scripture/core/engines/bible_compiler/source/packages/source_package.dart';
import 'package:open_scripture/core/sword/sword_bridge.dart';
import 'package:open_scripture/shared/data/services/source_fetcher_service.dart';
import 'package:open_scripture/shared/domain/entities/bible_download_progress.dart';
import 'package:open_scripture/shared/domain/entities/bible_source.dart';
import 'package:open_scripture/shared/domain/services/bible_installer_strategy.dart';
import 'package:path/path.dart' as p;

class SwordInstallerStrategy implements BibleInstallerStrategy {
  final SourceFetcherService _fetcher;
  final SwordBridge _swordBridge;

  /// TODO: this should come from the configuration
  final String _swordBasePath;

  SwordInstallerStrategy(
      {required SourceFetcherService fetcher,
      required SwordBridge swordBridge,
      required String swordBasePath})
      : _fetcher = fetcher,
        _swordBridge = swordBridge,
        _swordBasePath = swordBasePath;

  @override
  Stream<InstallProgress> install(BibleSourceType source) async* {
    try {
      yield InstallProgress(
          stage: InstallStage.downloading,
          message: 'Fetching Sword package...');
      // 1. Resolve source to the same agnostic package
      final sourcePackage = await _fetcher.resolveSource(source);

      yield const InstallProgress(
          stage: InstallStage.installing,
          message: 'Extracting Sword module...');

      if (sourcePackage.kind == SourcePackageKind.zip) {
        final entries = await sourcePackage.listEntries();

        for (final entry in entries) {
          // Read bytes via your agnostic SourcePackage interface
          final fileBytes = await sourcePackage.readBytes(entry.path);

          // Map internal zip paths straight to the local sword directory layout
          final targetPath = p.join(_swordBasePath, entry.path);
          final targetFile = File(targetPath);

          await targetFile.create(recursive: true);
          await targetFile.writeAsBytes(fileBytes);
        }
      } else {
        throw UnsupportedError(
            'Sword modules must be processed from a compressed archive archive.');
      }

      yield const InstallProgress(
          stage: InstallStage.installing,
          message: 'Synchronizing Sword engine...');
      // TODO: implement this method, as a workaround for now
      // delete the cache file in the modules path
      // await _swordBridge.refreshModules();

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
    final moduleName = bibleId.toString().toLowerCase();

    // TODO:
    // 1. Delete target files from mods.d and modules/ directories
    // 2. Refresh SwordBridge
  }
}
