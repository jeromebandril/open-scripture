part of 'installed_translations_bloc.dart';

sealed class InstalledTranslationsEvent extends Equatable {
  const InstalledTranslationsEvent();

  @override
  List<Object> get props => [];
}

final class InstalledTranslationsSubscriptionRequested
    extends InstalledTranslationsEvent {}

final class InstalledTranslationUninstall extends InstalledTranslationsEvent {
  final String id;

  const InstalledTranslationUninstall(this.id);
}
