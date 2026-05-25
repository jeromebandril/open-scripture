import 'dart:typed_data';

import 'package:open_scripture/core/engines/bible_compiler/source/packages/zip_source_package.dart';

import 'bytes_source_package.dart';
import 'file_source_package.dart';
import 'source_package.dart';

/// Creates [SourcePackage] from a local path or raw bytes.
final class SourcePackageFactory {
  const SourcePackageFactory();

  Future<SourcePackage> fromPath(String path) async {
    final lower = path.toLowerCase();

    // Heuristic: USFX commonly shipped as zip
    if (lower.endsWith('.zip')) {
      return ZipSourcePackage.fromFilePath(path);
    }

    // OSIS is often .xml, .osis, .osis.xml ... but treat as single-file.
    return FileSourcePackage.fromFilePath(path);
  }

  /// Useful for tests or when a feature downloads the source itself.
  SourcePackage fromBytes(
    Uint8List bytes, {
    String displayName = 'bytes',
  }) {
    return BytesSourcePackage(bytes: bytes, displayName: displayName);
  }
}
