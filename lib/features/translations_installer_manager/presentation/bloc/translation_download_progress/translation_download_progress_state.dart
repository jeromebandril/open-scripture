part of 'translation_download_progress_bloc.dart';

enum TranslationDownloadProgressStatus {
  initial,
  loaded,
  error,
}

class TranslationDownloadProgressState extends Equatable {
  const TranslationDownloadProgressState({
    this.status = TranslationDownloadProgressStatus.initial,
    this.downloadingTranslations = const {},
    this.downloadingProgresses = const {},
  });

  final TranslationDownloadProgressStatus status;
  final Map<String, TranslationInfo> downloadingTranslations;
  final Map<String, StreamSubscription> downloadingProgresses;

  TranslationDownloadProgressState copyWith({
    TranslationDownloadProgressStatus Function()? status,
    int Function()? totalBytes,
    int Function()? receivedBytes,
    Map<String, TranslationInfo> Function()? downloadingTranslations,
    Map<String, StreamSubscription> Function()? downloadingProgresses,
  }) {
    return TranslationDownloadProgressState(
      status: status != null ? status() : this.status,
      downloadingTranslations: downloadingTranslations != null
          ? downloadingTranslations()
          : this.downloadingTranslations,
    );
  }

  // exclude downloadingProgresses, becauses i coupled with downloadinTranslations
  @override
  List<Object?> get props => [status, downloadingTranslations];
}
