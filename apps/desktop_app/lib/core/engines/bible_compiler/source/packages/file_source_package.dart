import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;

import 'source_package.dart';

final class FileSourcePackage implements SourcePackage {
  final File _file;

  @override
  final String displayName;

  FileSourcePackage._(this._file, {required this.displayName});

  factory FileSourcePackage.fromFilePath(String path) {
    final file = File(path);
    return FileSourcePackage._(
      file,
      displayName: p.basename(path),
    );
  }

  @override
  SourcePackageKind get kind => SourcePackageKind.file;

  @override
  Future<List<PackageEntry>> listEntries() async {
    final stat = await _file.stat();
    return [PackageEntry(path: 'main', size: stat.size)];
  }

  @override
  Future<bool> exists(String entryPath) async {
    if (entryPath != 'main') return false;
    return _file.exists();
  }

  @override
  Future<Uint8List> readBytes(String entryPath) async {
    if (entryPath != 'main') {
      throw ArgumentError.value(
          entryPath, 'entryPath', 'Only "main" is valid for file packages.');
    }
    final bytes = await _file.readAsBytes();
    return Uint8List.fromList(bytes);
  }

  @override
  Future<String> readText(String entryPath, {Encoding encoding = utf8}) async {
    final bytes = await readBytes(entryPath);
    return encoding.decode(bytes);
  }

  @override
  Future<String?> tryReadText(String entryPath,
      {Encoding encoding = utf8}) async {
    final ok = await exists(entryPath);
    if (!ok) return null;
    return readText(entryPath, encoding: encoding);
  }

  @override
  Future<String> fingerprint() async {
    final bytes = await _file.readAsBytes();
    return sha256.convert(bytes).toString();
  }
}
