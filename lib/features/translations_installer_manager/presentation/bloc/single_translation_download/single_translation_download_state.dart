part of 'single_translation_download_bloc.dart';

enum SingleTranslationDownloadStatus {
  initial,
  error,
  paused,
  canceled,
  downloading,
  installing,
  installed,
}

class SingleTranslationDownloadState extends Equatable {
  const SingleTranslationDownloadState({
    this.status = SingleTranslationDownloadStatus.initial,
    this.totalBytes = 0,
    this.receivedBytes = 0,
  });

  final SingleTranslationDownloadStatus status;
  final int totalBytes;
  final int receivedBytes;

  SingleTranslationDownloadState copyWith({
    SingleTranslationDownloadStatus Function()? status,
    int Function()? totalBytes,
    int Function()? receivedBytes,
  }) {
    return SingleTranslationDownloadState(
      status: status != null ? status() : this.status,
      totalBytes: totalBytes != null ? totalBytes() : this.totalBytes,
      receivedBytes:
          receivedBytes != null ? receivedBytes() : this.receivedBytes,
    );
  }

  @override
  List<Object?> get props => [status];
}
