import 'dart:io';
import 'package:open_scripture/core/engines/bible_compiler/source/packages/zip_source_package.dart';
import 'package:path/path.dart' as p;

import 'package:open_scripture/core/engines/bible_compiler/source/packages/file_source_package.dart';
import 'package:open_scripture/core/engines/bible_compiler/source/packages/source_package.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/entities/bible_source.dart';

abstract interface class SourceFetcherService {
  /// Resolves a declarative [BibleSource] into a physical, readable [SourcePackage].
  /// If it's a remote source, this handles downloading it to a secure temporary cache.
  Future<SourcePackage> resolveSource(BibleSource source);

  /// Cleans up any temporary files or cache allocations associated with the source.
  /// Call this in a `finally` block during your installation pipeline.
  Future<void> cleanup(BibleSource source);
}

class SourceFetcherServiceImpl implements SourceFetcherService {
  // Track temporary download paths to clean them up accurately later
  final Map<BibleSource, String> _tempFileTracker = {};

  @override
  Future<SourcePackage> resolveSource(BibleSource source) async {
    return switch (source) {
      LocalFileSource() => _resolveLocalSource(source),
      RemoteNetworkSource() => await _resolveRemoteSource(source),
    };
  }

  SourcePackage _resolveLocalSource(LocalFileSource source) {
    final file = File(source.filePath);
    if (!file.existsSync()) {
      throw FileSystemException(
          'Local file import failed: File not found', source.filePath);
    }

    if (_isZipFile(file)) {
      return ZipSourcePackage.fromFilePath(source.filePath);
    }

    // Wrap your local physical file straight into a standard SourcePackage
    return FileSourcePackage(file: file, displayName: source.displayName);
  }

  Future<SourcePackage> _resolveRemoteSource(RemoteNetworkSource source) async {
    // 1. Locate the system's secure temporary directory
    final tempDir = await getTemporaryDirectory();

    // 2. Generate a deterministic temporary name (e.g., using a hash or timestamp)
    final fileName =
        '${source.displayName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}_${DateTime.now().millisecondsSinceEpoch}.tmp';
    final destinationPath = p.join(tempDir.path, fileName);
    final destinationFile = File(destinationPath);

    // 3. Execute the network download logic (Your FTPS/HTTP implementation)
    try {
      if (source.url.scheme == 'ftps' || source.url.scheme == 'ftp') {
        // TODO: Initialize your FTPS client here using source.credentials
        // await ftpsClient.download(source.url, destinationFile);
      } else {
        // Fallback or explicit HTTP download
        // final response = await httpClient.get(source.url);
        // await destinationFile.writeAsBytes(response.bodyBytes);
      }
    } catch (e) {
      throw HttpException(
          'Network download failed for ${source.displayName}: $e',
          uri: source.url);
    }

    // 4. Track this file so we know exactly what to purge during cleanup
    _tempFileTracker[source] = destinationPath;

    return FileSourcePackage(
        file: destinationFile, displayName: source.displayName);
  }

  @override
  Future<void> cleanup(BibleSource source) async {
    final trackedPath = _tempFileTracker.remove(source);

    // Local files aren't tracked and are kept safe
    if (trackedPath == null) return;

    try {
      final file = File(trackedPath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // Log or suppress cleanup errors so they never disrupt an ongoing UI stream
    }
  }

  // -- helpers

  /// Inspects the first 4 bytes of a file to check for the ZIP signature.
  bool _isZipFile(File file) {
    try {
      final randomAccessFile = file.openSync(mode: FileMode.read);
      final headerBytes = randomAccessFile.readSync(4);
      randomAccessFile.closeSync();

      if (headerBytes.length < 4) return false;

      // ZIP magic number: PK\x03\x04
      return headerBytes[0] == 0x50 && // P
          headerBytes[1] == 0x4B && // K
          headerBytes[2] == 0x03 &&
          headerBytes[3] == 0x04;
    } catch (_) {
      return false; // Safely handle read failures as non-zip
    }
  }
}
