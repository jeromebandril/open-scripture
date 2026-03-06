part of 'installed_bibles_bloc.dart';

enum InstalledBiblesStatus {
  initial,
  loading,
  loaded,
  error,
}

class InstalledBiblesState extends Equatable {
  const InstalledBiblesState({
    this.status = InstalledBiblesStatus.initial,
    this.installedBibles = const [],
    this.errorMessage,
    this.selectedBibleId,
  });

  final InstalledBiblesStatus status;
  final List<BibleMeta> installedBibles;
  final String? selectedBibleId;
  final String? errorMessage;

  InstalledBiblesState copyWith({
    InstalledBiblesStatus Function()? status,
    List<BibleMeta> Function()? installedBibles,
    String? Function()? selectedBibleId,
    String Function()? errorMessage,
  }) {
    return InstalledBiblesState(
      status: status != null ? status() : this.status,
      installedBibles:
          installedBibles != null ? installedBibles() : this.installedBibles,
      selectedBibleId:
          selectedBibleId != null ? selectedBibleId() : this.selectedBibleId,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, installedBibles, selectedBibleId, errorMessage];
}
