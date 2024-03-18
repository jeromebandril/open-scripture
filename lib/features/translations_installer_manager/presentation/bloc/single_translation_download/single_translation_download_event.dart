part of 'single_translation_download_bloc.dart';

class SingleTranslationDownloadEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SIngleTranslationDownloadSubscriptionRequested
    extends SingleTranslationDownloadEvent {}

class SingleTranslationDownloadPause extends SingleTranslationDownloadEvent {}

class SingleTranslationDownloadResume extends SingleTranslationDownloadEvent {}

class SingleTranslationDownloadCancel extends SingleTranslationDownloadEvent {}

class SingleTranslationDownloadPressed extends SingleTranslationDownloadEvent {
  final String id;

  SingleTranslationDownloadPressed(this.id);

  @override
  List<Object?> get props => [id];
}
