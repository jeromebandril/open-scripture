import 'package:equatable/equatable.dart';

enum DownloadStatus {
  notDownloaded,
  downloading,
  installing,
  installed,
}

class TranslationInfo extends Equatable {
  // translation general metadata
  final String id;
  final String name;
  final String language;
  // download stats
  final DownloadStatus downloadStatus;

  const TranslationInfo({
    required this.id,
    required this.name,
    required this.language,
    this.downloadStatus = DownloadStatus.notDownloaded,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        language,
        downloadStatus,
      ];
}
