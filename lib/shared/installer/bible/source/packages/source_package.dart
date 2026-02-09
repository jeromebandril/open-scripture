import 'dart:convert';
import 'dart:typed_data';

enum SourcePackageKind { file, zip, bytes }

final class PackageEntry {
  final String path;
  final int? size;

  const PackageEntry({required this.path, this.size});
}

abstract interface class SourcePackage {
  SourcePackageKind get kind;

  /// For logs/UI only (e.g., "kjv.osis.xml" or "usfx_bundle.zip").
  String get displayName;

  /// Stable-ish identifier for caching/idempotency. Usually a hash of the entire source.
  Future<String> fingerprint();

  /// Lists all readable entries (files) contained in the package.
  Future<List<PackageEntry>> listEntries();

  /// Returns true if an entry exists.
  Future<bool> exists(String entryPath);

  /// Read an entry as bytes.
  Future<Uint8List> readBytes(String entryPath);

  /// Read an entry as text. Default utf8.
  Future<String> readText(
    String entryPath, {
    Encoding encoding = utf8,
  });

  /// Like readText, but returns null if missing.
  Future<String?> tryReadText(
    String entryPath, {
    Encoding encoding = utf8,
  });
}
