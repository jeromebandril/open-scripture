import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:open_scripture/core/engines/bible_compiler/source/packages/source_package.dart';

class FileSourcePackage implements SourcePackage {
  final File file;
  @override
  final String displayName;

  FileSourcePackage({required this.file, required this.displayName});

  @override
  SourcePackageKind get kind => SourcePackageKind.file;

  @override
  Future<String> fingerprint() async {
    // Generate a quick SHA-256 fingerprint of the file path + size for caching/idempotency
    final length = await file.length();
    final bytes = utf8.encode('${file.path}_$length');
    return sha256.convert(bytes).toString();
  }

  @override
  Future<List<PackageEntry>> listEntries() async {
    // A single raw file package exposes exactly one readable entry
    return [
      PackageEntry(path: 'root', size: await file.length()),
    ];
  }

  @override
  Future<bool> exists(String entryPath) async {
    return await file.exists();
  }

  @override
  Future<Uint8List> readBytes(String entryPath) async {
    return await file.readAsBytes();
  }

  @override
  Future<String> readText(String entryPath, {Encoding encoding = utf8}) async {
    return await file.readAsString(encoding: encoding);
  }

  @override
  Future<String?> tryReadText(String entryPath,
      {Encoding encoding = utf8}) async {
    try {
      return await readText(entryPath, encoding: encoding);
    } catch (_) {
      return null;
    }
  }
}
