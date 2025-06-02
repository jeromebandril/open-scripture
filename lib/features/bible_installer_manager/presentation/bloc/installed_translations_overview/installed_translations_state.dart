part of 'installed_translations_bloc.dart';

enum InstalledTranslationsStatus {
  initial,
  loading,
  loaded,
  error,
}

class InstalledTranslationsState extends Equatable {
  const InstalledTranslationsState({
    this.status = InstalledTranslationsStatus.initial,
    this.installedTranslations = const [],
    this.errorMessage,
  });

  final InstalledTranslationsStatus status;
  final List<EBible> installedTranslations;
  final String? errorMessage;

  InstalledTranslationsState copyWith({
    InstalledTranslationsStatus Function()? status,
    List<EBible> Function()? installedTranslationsInfos,
    String Function()? errorMessage,
  }) {
    return InstalledTranslationsState(
      status: status != null ? status() : this.status,
      installedTranslations: installedTranslationsInfos != null
          ? installedTranslationsInfos()
          : installedTranslations,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, installedTranslations, errorMessage];
}
