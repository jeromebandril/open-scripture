part of 'settings_bloc.dart';

enum SettingsStatus {
  close,
  open,
}

class SettingsState extends Equatable {
  const SettingsState({
    this.status = SettingsStatus.close,
    this.currentPage,
  });

  final SettingsStatus status;
  final String? currentPage;

  SettingsState copyWith({
    SettingsStatus Function()? status,
    String? Function()? currentOpenWindow,
  }) {
    return SettingsState(
      status: status != null ? status() : this.status,
      currentPage:
          currentOpenWindow != null ? currentOpenWindow() : currentPage,
    );
  }

  @override
  List<Object?> get props => [status, currentPage];
}
