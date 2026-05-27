part of 'installer_bloc.dart';

enum InstalledBiblesStatus {
  initial,
  loading,
  loaded,
  error,
}

class InstallerState extends Equatable {
  const InstallerState({
    this.status = InstalledBiblesStatus.initial,
    this.errorMessage,
  });

  final InstalledBiblesStatus status;
  final String? errorMessage;

  InstallerState copyWith({
    InstalledBiblesStatus Function()? status,
    String? Function()? selectedBibleId,
    String Function()? errorMessage,
  }) {
    return InstallerState(
      status: status != null ? status() : this.status,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
