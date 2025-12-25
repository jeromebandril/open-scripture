part of 'download_manager_bloc.dart';

class DownloadManagerState extends Equatable {
  final Map<String, InstallProgress> progressByBibleId;

  const DownloadManagerState({this.progressByBibleId = const {}});

  DownloadManagerState copyWith({
    Map<String, InstallProgress>? progressByBibleId,
  }) =>
      DownloadManagerState(
        progressByBibleId: progressByBibleId ?? this.progressByBibleId,
      );

  @override
  List<Object?> get props => [progressByBibleId];
}
