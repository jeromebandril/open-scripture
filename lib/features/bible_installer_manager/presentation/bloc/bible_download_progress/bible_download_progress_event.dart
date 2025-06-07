part of 'bible_download_progress_bloc.dart';

class TranslationDownloadProgressEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TranslationDownloadProgressSubscriptionRequested
    extends TranslationDownloadProgressEvent {}

class BibleDownloadProgressPause extends TranslationDownloadProgressEvent {
  final String id;

  BibleDownloadProgressPause(this.id);

  @override
  List<Object?> get props => [id];
}

class BibleDownloadProgressResume extends TranslationDownloadProgressEvent {
  final String id;

  BibleDownloadProgressResume(this.id);

  @override
  List<Object?> get props => [id];
}

class BibleDownloadProgressCancel extends TranslationDownloadProgressEvent {}

class BibleDownloadProgressPressed extends TranslationDownloadProgressEvent {
  final EBible bible;

  BibleDownloadProgressPressed(this.bible);

  @override
  List<Object?> get props => [bible];
}
