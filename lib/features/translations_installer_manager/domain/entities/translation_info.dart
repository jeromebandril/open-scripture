import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/domain/entities/translation.dart';

enum DownloadStatus {
  notDownloaded,
  paused,
  canceled,
  downloading,
  downloaded,
  installing,
  installed,
}

class TranslationInfo extends Equatable {
  final String id;
  final String name;
  final String language;
  final int total;
  final int received;
  final DownloadStatus downloadStatus;

  const TranslationInfo({
    required this.id,
    required this.name,
    required this.language,
    this.total = 0,
    this.received = 0,
    this.downloadStatus = DownloadStatus.notDownloaded,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        language,
        downloadStatus,
        total,
        received,
      ];

  TranslationInfo copyWith({
    int Function()? total,
    int Function()? received,
    DownloadStatus Function()? downloadStatus,
  }) {
    return TranslationInfo(
      id: this.id,
      name: this.name,
      language: this.language,
      total: total != null ? total() : this.total,
      received: received != null ? received() : this.received,
      downloadStatus:
          downloadStatus != null ? downloadStatus() : this.downloadStatus,
    );
  }
}
