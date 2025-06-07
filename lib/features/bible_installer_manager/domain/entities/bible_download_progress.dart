import 'package:equatable/equatable.dart';

enum DownloadStatus {
  notDownloaded,
  paused,
  canceled,
  inProgress,
  downloaded,
  installing,
  installed,
}

class DownloadProgess extends Equatable {
  final int total;
  final int received;
  final DownloadStatus downloadStatus;

  const DownloadProgess({
    this.total = 0,
    this.received = 0,
    this.downloadStatus = DownloadStatus.notDownloaded,
  });

  @override
  List<Object?> get props => [
        downloadStatus,
        total,
        received,
      ];

  DownloadProgess copyWith({
    int Function()? total,
    int Function()? received,
    DownloadStatus Function()? downloadStatus,
  }) {
    return DownloadProgess(
      total: total != null ? total() : this.total,
      received: received != null ? received() : this.received,
      downloadStatus:
          downloadStatus != null ? downloadStatus() : this.downloadStatus,
    );
  }
}
