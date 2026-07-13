import 'dart:typed_data';

sealed class BibleSourceType {
  final String displayName;
  const BibleSourceType({required this.displayName});
}

/// For files already on the device (Import Feature)
class LocalFileSource extends BibleSourceType {
  final String filePath;
  const LocalFileSource({required this.filePath, required super.displayName});
}

/// For fetching from your FTPS or cloud storage (Download Feature)
class RemoteNetworkSource extends BibleSourceType {
  final Uri url;
  // E.g., auth tokens, FTPS credentials, or API keys
  final Map<String, String>? credentials;

  const RemoteNetworkSource({
    required this.url,
    this.credentials,
    required super.displayName,
  });
}

/// For files picked in-memory (e.g. Flutter Web, where no real file path exists)
class MemoryFileSource extends BibleSourceType {
  final Uint8List bytes;
  const MemoryFileSource({required this.bytes, required super.displayName});
}
