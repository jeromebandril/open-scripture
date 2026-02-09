import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;

import 'source_package.dart';

final class ZipSourcePackage implements SourcePackage {
  final String _filePath;
  final Archive _archive;

  @override
  final String displayName;

  ZipSourcePackage._(
    this._filePath,
    this._archive, {
    required this.displayName,
  });

  factory ZipSourcePackage.fromFilePath(String path) {
    final bytes = File(path).readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes, verify: true);
    return ZipSourcePackage._(
      path,
      archive,
      displayName: p.basename(path),
    );
  }

  @override
  SourcePackageKind get kind => SourcePackageKind.zip;

  @override
  Future<List<PackageEntry>> listEntries() async {
    final entries = <PackageEntry>[];
    for (final f in _archive.files) {
      if (f.isFile) {
        entries.add(PackageEntry(
          path: _normalize(f.name),
          size: f.size,
        ));
      }
    }
    return entries;
  }

  @override
  Future<bool> exists(String entryPath) async {
    final wanted = _normalize(entryPath);
    return _archive.files.any((f) => f.isFile && _normalize(f.name) == wanted);
  }

  @override
  Future<Uint8List> readBytes(String entryPath) async {
    final wanted = _normalize(entryPath);
    final file = _archive.files.firstWhere(
      (f) => f.isFile && _normalize(f.name) == wanted,
      orElse: () => throw ArgumentError.value(
          entryPath, 'entryPath', 'Entry not found in zip.'),
    );

    final content = file.content;
    if (content is List<int>) {
      return Uint8List.fromList(content);
    }
    if (content is Uint8List) {
      return Uint8List.fromList(content);
    }

    // archive sometimes stores content lazily; ensure bytes materialize
    return Uint8List.fromList(file.content as List<int>);
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
    final bytes = await File(_filePath).readAsBytes();
    return sha256.convert(bytes).toString();
  }

  static String _normalize(String path) {
    return path.replaceAll('\\', '/');
  }
}
