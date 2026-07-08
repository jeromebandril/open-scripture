import 'dart:convert';
import 'dart:typed_data';

final class PackageEntry {
  final String path;
  final int? size;

  const PackageEntry({required this.path, this.size});
}

sealed class SourcePackage {
  String get displayName;
  Future<String> fingerprint();
}

abstract interface class LeafPackage implements SourcePackage {
  Future<Uint8List> readBytes();
  Future<String> readText({Encoding encoding = utf8});
}

abstract interface class ContainerPackage implements SourcePackage {
  List<PackageEntry> listEntries();
  bool exists(String entryPath);
  Future<LeafPackage> open(String entryPath);
  Future<void> dispose();
}
