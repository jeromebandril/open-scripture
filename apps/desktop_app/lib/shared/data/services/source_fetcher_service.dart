import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/engines/bible_compiler/source/packages/bytes_source_package.dart';
import '../../../core/engines/bible_compiler/source/packages/file_source_package.dart';
import '../../../core/engines/bible_compiler/source/packages/source_package.dart';
import '../../domain/entities/bible_source.dart';

abstract interface class SourceFetcherService {
  /// Resolves a declarative [BibleSourceType] into a physical, readable [SourcePackage].
  /// If it's a remote source, this handles downloading it to a secure temporary cache.
  Future<SourcePackage> resolveSource(BibleSourceType source);

  /// Cleans up any temporary files or cache allocations associated with the source.
  /// Call this in a `finally` block during your installation pipeline.
  Future<void> cleanup(BibleSourceType source);
}

class SourceFetcherServiceImpl implements SourceFetcherService {
  // Track temporary download paths to clean them up accurately later
  final Map<BibleSourceType, String> _tempFileTracker = {};
  final Map<BibleSourceType, SourcePackage> _packageTracker = {};

  @override
  Future<SourcePackage> resolveSource(BibleSourceType source) async {
    final package = switch (source) {
      LocalFileSource() => _resolveLocalSource(source),
      RemoteNetworkSource() => await _resolveRemoteSource(source),
      MemoryFileSource() => await _resolveMemorySource(source),
    };
    _packageTracker[source] = package;
    return package;
  }

  SourcePackage _resolveLocalSource(LocalFileSource source) {
    final file = File(source.filePath);
    if (!file.existsSync()) {
      throw FileSystemException(
          'Local file import failed: File not found', source.filePath);
    }
    return _classifyFile(file, displayName: source.displayName);
  }

  Future<SourcePackage> _resolveRemoteSource(RemoteNetworkSource source) async {
    final tempDir = await getTemporaryDirectory();

    final fileName =
        '${source.displayName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}_${DateTime.now().millisecondsSinceEpoch}.tmp';
    final destinationPath = p.join(tempDir.path, fileName);
    final destinationFile = File(destinationPath);

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

    _tempFileTracker[source] = destinationPath;

    return _classifyFile(destinationFile, displayName: source.displayName);
  }

  Future<SourcePackage> _resolveMemorySource(MemoryFileSource source) async {
    if (_isZipBytes(source.bytes)) {
      return await BytesContainerPackage.fromZipBytes(
        source.bytes,
        displayName: source.displayName,
      );
    }
    return BytesLeafPackage(
      bytes: source.bytes,
      displayName: source.displayName,
    );
  }

  @override
  Future<void> cleanup(BibleSourceType source) async {
    final package = _packageTracker.remove(source);
    if (package is ContainerPackage) {
      await package.dispose();
    }

    final trackedPath = _tempFileTracker.remove(source);
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

  // ------------------ helpers -------------------------------------------

  /// Classifies a file on disk and wraps it in the appropriate package type,
  /// using the streaming (non-eager) container/leaf variants.
  SourcePackage _classifyFile(File file, {required String displayName}) {
    if (_isZipFile(file)) {
      return FileContainerPackage.open(file.path, displayName: displayName);
    }
    return FileLeafPackage(path: file.path, displayName: displayName);
  }

  /// Inspects the first 4 bytes of a file to check for the ZIP signature.
  bool _isZipFile(File file) {
    try {
      final randomAccessFile = file.openSync(mode: FileMode.read);
      final headerBytes = randomAccessFile.readSync(4);
      randomAccessFile.closeSync();
      return _isZipBytes(headerBytes);
    } catch (_) {
      return false;
    }
  }

  bool _isZipBytes(Uint8List bytes) {
    if (bytes.length < 4) return false;
    return bytes[0] == 0x50 && // P
        bytes[1] == 0x4B && // K
        bytes[2] == 0x03 &&
        bytes[3] == 0x04;
  }
}
