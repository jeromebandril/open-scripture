import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

import 'source_package.dart';

final class BytesLeafPackage implements LeafPackage {
  final Uint8List _bytes;
  @override
  final String displayName;
  BytesLeafPackage({required Uint8List bytes, required this.displayName})
      : _bytes = bytes;

  @override
  Future<Uint8List> readBytes() async => _bytes;
  @override
  Future<String> readText({Encoding encoding = utf8}) async =>
      encoding.decode(_bytes);
  @override
  Future<String> fingerprint() async => sha256.convert(_bytes).toString();
}

final class BytesContainerPackage implements ContainerPackage {
  final Archive _archive;
  @override
  final String displayName;
  final Uint8List _rawBytes;

  BytesContainerPackage._(this._archive, this._rawBytes,
      {required this.displayName});

  static Future<BytesContainerPackage> fromZipBytes(
    Uint8List bytes, {
    required String displayName,
  }) async {
    Archive decodeZip(Uint8List bytes) {
      return ZipDecoder().decodeBytes(bytes, verify: true);
    }

    final archive = await compute(decodeZip, bytes);
    return BytesContainerPackage._(archive, bytes, displayName: displayName);
  }

  @override
  List<PackageEntry> listEntries() => _archive.files
      .where((f) => f.isFile)
      .map((f) => PackageEntry(path: _normalize(f.name), size: f.size))
      .toList();

  @override
  bool exists(String entryPath) => _archive.files
      .any((f) => f.isFile && _normalize(f.name) == _normalize(entryPath));

  @override
  Future<LeafPackage> open(String entryPath) async {
    final f = _archive.files.firstWhere(
        (f) => f.isFile && _normalize(f.name) == _normalize(entryPath));
    return BytesLeafPackage(
        bytes: Uint8List.fromList(f.content as List<int>), displayName: f.name);
  }

  @override
  Future<String> fingerprint() async => sha256.convert(_rawBytes).toString();

  @override
  Future<void> dispose() async {} // nothing to release

  static String _normalize(String p) => p.replaceAll('\\', '/');
}
