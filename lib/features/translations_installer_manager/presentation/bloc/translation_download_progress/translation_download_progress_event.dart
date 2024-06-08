part of 'translation_download_progress_bloc.dart';

class TranslationDownloadProgressEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TranslationDownloadProgressSubscriptionRequested
    extends TranslationDownloadProgressEvent {}

class TranslationDownloadProgressPause
    extends TranslationDownloadProgressEvent {
  final String id;

  TranslationDownloadProgressPause(this.id);

  @override
  List<Object?> get props => [id];
}

class TranslationDownloadProgressResume
    extends TranslationDownloadProgressEvent {
  final String id;

  TranslationDownloadProgressResume(this.id);

  @override
  List<Object?> get props => [id];
}

class TranslationDownloadProgressCancel
    extends TranslationDownloadProgressEvent {}

class TranslationDownloadProgressPressed
    extends TranslationDownloadProgressEvent {
  final String id;

  TranslationDownloadProgressPressed(this.id);

  @override
  List<Object?> get props => [id];
}
