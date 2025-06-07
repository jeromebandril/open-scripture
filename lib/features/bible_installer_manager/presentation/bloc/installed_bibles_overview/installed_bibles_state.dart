part of 'installed_bibles_bloc.dart';

enum InstalledTranslationsStatus {
  initial,
  loading,
  loaded,
  error,
}

class InstalledBiblesState extends Equatable {
  const InstalledBiblesState({
    this.status = InstalledTranslationsStatus.initial,
    this.installedTranslations = const [],
    this.errorMessage,
  });

  final InstalledTranslationsStatus status;
  final List<EBible> installedTranslations;
  final String? errorMessage;

  InstalledBiblesState copyWith({
    InstalledTranslationsStatus Function()? status,
    List<EBible> Function()? installedBibles,
    String Function()? errorMessage,
  }) {
    return InstalledBiblesState(
      status: status != null ? status() : this.status,
      installedTranslations:
          installedBibles != null ? installedBibles() : installedTranslations,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, installedTranslations, errorMessage];
}
