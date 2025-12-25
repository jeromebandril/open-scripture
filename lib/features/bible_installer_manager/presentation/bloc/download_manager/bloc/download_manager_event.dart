part of 'download_manager_bloc.dart';

sealed class DownloadManagerEvent extends Equatable {
  const DownloadManagerEvent();

  @override
  List<Object> get props => [];
}

class StartInstall extends DownloadManagerEvent {
  final String bibleId;

  const StartInstall(this.bibleId);

  @override
  List<Object> get props => [bibleId];
}

class _ProgressUpdate extends DownloadManagerEvent {
  final String bibleId;
  final InstallProgress progress;

  const _ProgressUpdate(this.bibleId, this.progress);

  @override
  List<Object> get props => [bibleId, progress];
}

class CancelInstall extends DownloadManagerEvent {
  final String bibleId;

  const CancelInstall(this.bibleId);

  @override
  List<Object> get props => [bibleId];
}
