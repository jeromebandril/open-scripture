part of 'bible_download_progress_bloc.dart';

class BibleDownloadProgressState extends Equatable {
  const BibleDownloadProgressState({
    this.bible,
    this.progress,
    this.errorMessage,
  });

  final BibleMeta? bible;
  final InstallProgress? progress;
  final String? errorMessage;

  BibleDownloadProgressState copyWith({
    InstallProgress Function()? progress,
    BibleMeta Function()? bible,
    String Function()? errorMessage,
  }) {
    return BibleDownloadProgressState(
      bible: bible != null ? bible() : this.bible,
      progress: progress != null ? progress() : this.progress,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [bible, progress, errorMessage];
}
