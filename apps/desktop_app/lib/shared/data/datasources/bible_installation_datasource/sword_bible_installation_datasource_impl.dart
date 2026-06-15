import 'dart:io';

import 'package:open_scripture/core/engines/bible_compiler/source/packages/source_package.dart';
import 'package:open_scripture/core/sword/sword_bridge.dart';
import 'package:path/path.dart' as p;

abstract class SwordInstallationDatasource {
  /// Handles the physical extraction and writing of bytes to the disk
  Future<void> extractAndInstallModule({
    required SourcePackage package,
    required String targetBasePath,
  });

  /// Handles the physical deletion of configuration and text files
  Future<void> deleteModuleFiles({
    required String moduleCode,
    required String basePath,
  });

  /// Purges the cache so the C++ engine refreshes
  Future<void> clearEngineCache({required String basePath});
}

class SwordBibleInstallationDatasourceImpl
    implements SwordInstallationDatasource {
  final SwordBridge _swordBridge;

  const SwordBibleInstallationDatasourceImpl({required SwordBridge swordBridge})
      : _swordBridge = swordBridge;

  @override
  Future<void> clearEngineCache({required String basePath}) async {
    // I need to delete the /mods.d/modules-conf.cache file to refresh
    final modsDDir = Directory(p.join(basePath, 'mods.d'));
    final targetFile = File(p.join(modsDDir.path, 'modules-conf.cache'));

    if (await targetFile.exists()) {
      try {
        // 3. Delete the file
        await targetFile.delete();
        print('Successfully deleted modules-conf.cache');
      } catch (e) {
        print('Error deleting file: $e');
        throw e;
      }
    } else {
      print('The file modules-conf.cache does not exist in this directory.');
    }

    // re-init
    _swordBridge.init(basePath);
  }

  @override
  Future<void> deleteModuleFiles(
      {required String moduleCode, required String basePath}) async {
    final String lowerModuleCode = moduleCode.toLowerCase();

    // 2. Locate the configuration file inside mods.d
    // We check case-insensitively to support both 'kjv.conf' and 'KJV.conf'
    final modsDDir = Directory(p.join(basePath, 'mods.d'));
    File? confFile;

    if (await modsDDir.exists()) {
      final files = modsDDir.listSync();
      for (final file in files) {
        if (p.basename(file.path).toLowerCase() == '$lowerModuleCode.conf') {
          confFile = File(file.path);
          break;
        }
      }
    }

    if (confFile == null || !await confFile.exists()) {
      throw FileSystemException(
          'Configuration file for module $moduleCode not found.');
    }

    // 3. Parse the configuration file to find the exact dynamic DataPath
    String? relativeDataPath;
    final lines = await confFile.readAsLines();
    for (final line in lines) {
      if (line.toLowerCase().startsWith('datapath=')) {
        // Extracts everything after the '=' sign (e.g., './modules/texts/ztext/kjv/')
        relativeDataPath = line.split('=').last.trim();
        break;
      }
    }

    // 4. Perform the clean-up sequence
    try {
      // Delete the binary text blocks directory
      if (relativeDataPath != null) {
        // Clean up the SWORD relative dot prefix if present (e.g., './modules' -> 'modules')
        final cleanRelativePath =
            relativeDataPath.replaceFirst(RegExp(r'^\./'), '');
        final dataDir = Directory(p.join(basePath, cleanRelativePath));

        if (await dataDir.exists()) {
          await dataDir.delete(recursive: true);
        }
      } else {
        // Fallback: If DataPath tag was missing, guess standard convention placement
        final fallbackDataDir = Directory(
            p.join(basePath, 'modules', 'texts', 'ztext', lowerModuleCode));
        if (await fallbackDataDir.exists()) {
          await fallbackDataDir.delete(recursive: true);
        }
      }

      // Delete the configuration definition file
      await confFile.delete();

      // 5. Purge the global SWORD cache file
      // If skipped, the native library will read stale registration definitions
      final globalCacheFile =
          File(p.join(basePath, 'mods.d', 'modules-conf.cache'));
      if (await globalCacheFile.exists()) {
        await globalCacheFile.delete();
      }

      // 6. Synchronize the active FFI instance
      // Cycle the engine on/off to flush system memory allocation cleanly
      // final swordBridge = await sl.getAsync<SwordBridge>();
      // swordBridge.shutdown();
      // swordBridge.init(basePath);
    } catch (e) {
      throw Exception(
          'Failed to cleanly uninstall SWORD module $moduleCode: $e');
    }
  }

  @override
  Future<void> extractAndInstallModule(
      {required SourcePackage package, required String targetBasePath}) async {
    if (package.kind != SourcePackageKind.zip) {
      throw UnsupportedError(
          'Sword modules must be processed from a compressed archive archive.');
    }

    final entries = await package.listEntries();

    for (final entry in entries) {
      // Read bytes via your agnostic SourcePackage interface
      final fileBytes = await package.readBytes(entry.path);

      // Map internal zip paths straight to the local sword directory layout
      final targetPath = p.join(targetBasePath, entry.path);
      final targetFile = File(targetPath);

      await targetFile.create(recursive: true);
      await targetFile.writeAsBytes(fileBytes);
    }
  }
}
