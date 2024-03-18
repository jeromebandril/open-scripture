part of 'all_translations_bloc.dart';

enum AllTranslationsStatus {
  initial,
  loading,
  loaded,
  error,
}

class AllTranslationsState extends Equatable {
  const AllTranslationsState({
    this.status = AllTranslationsStatus.initial,
    this.translationInfos = const [],
    this.errorMessage,
  });

  final AllTranslationsStatus status;
  final List<TranslationInfo> translationInfos;
  final String? errorMessage;

  AllTranslationsState copyWith({
    AllTranslationsStatus Function()? status,
    List<TranslationInfo> Function()? translationInfos,
    String Function()? errorMessage,
  }) {
    return AllTranslationsState(
      status: status != null ? status() : this.status,
      translationInfos:
          translationInfos != null ? translationInfos() : this.translationInfos,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  List<TranslationInfo> getDownloadingList() => translationInfos
      .where((t) => t.downloadStatus == DownloadStatus.downloading)
      .toList();

  @override
  List<Object> get props => [status, translationInfos];
}
