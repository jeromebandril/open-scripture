import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive_io.dart';
import 'package:crypto/crypto.dart';

import 'bytes_source_package.dart';
import 'source_package.dart';

final class FileLeafPackage implements LeafPackage {
  final String _path;
  @override
  final String displayName;
  FileLeafPackage({required String path, required this.displayName})
      : _path = path;

  @override
  Future<Uint8List> readBytes() => File(_path).readAsBytes();
  @override
  Future<String> readText({Encoding encoding = utf8}) =>
      File(_path).readAsString(encoding: encoding);

  @override
  Future<String> fingerprint() async =>
      (await sha256.bind(File(_path).openRead()).first).toString();
}

final class FileContainerPackage implements ContainerPackage {
  final String _path;
  final InputFileStream _input;
  final Archive _archive;
  @override
  final String displayName;

  FileContainerPackage._(this._path, this._input, this._archive,
      {required this.displayName});

  factory FileContainerPackage.open(String path,
      {required String displayName}) {
    final input = InputFileStream(path);
    return FileContainerPackage._(path, input, ZipDecoder().decodeStream(input),
        displayName: displayName);
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
  Future<String> fingerprint() async =>
      (await sha256.bind(File(_path).openRead()).first).toString();

  @override
  Future<void> dispose() => _input.close();

  static String _normalize(String p) => p.replaceAll('\\', '/');
}
