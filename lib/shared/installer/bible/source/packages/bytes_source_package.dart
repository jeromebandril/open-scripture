// lib/shared/installer/bible/source/packages/bytes_source_package.dart

import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import 'source_package.dart';

final class BytesSourcePackage implements SourcePackage {
  final Uint8List _bytes;

  @override
  final String displayName;

  BytesSourcePackage({
    required Uint8List bytes,
    required this.displayName,
  }) : _bytes = Uint8List.fromList(bytes);

  @override
  SourcePackageKind get kind => SourcePackageKind.bytes;

  @override
  Future<List<PackageEntry>> listEntries() async {
    return [PackageEntry(path: 'main', size: _bytes.length)];
  }

  @override
  Future<bool> exists(String entryPath) async => entryPath == 'main';

  @override
  Future<Uint8List> readBytes(String entryPath) async {
    if (entryPath != 'main') {
      throw ArgumentError.value(
          entryPath, 'entryPath', 'Only "main" is valid for bytes packages.');
    }
    return Uint8List.fromList(_bytes);
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
    return sha256.convert(_bytes).toString();
  }
}
