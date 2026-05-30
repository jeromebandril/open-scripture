sealed class BibleSource {
  final String displayName;
  const BibleSource({required this.displayName});
}

/// For files already on the device (Import Feature)
class LocalFileSource extends BibleSource {
  final String filePath;
  const LocalFileSource({required this.filePath, required super.displayName});
}

/// For fetching from your FTPS or cloud storage (Download Feature)
class RemoteNetworkSource extends BibleSource {
  final Uri url;
  // E.g., auth tokens, FTPS credentials, or API keys
  final Map<String, String>? credentials;

  const RemoteNetworkSource({
    required this.url,
    this.credentials,
    required super.displayName,
  });
}
