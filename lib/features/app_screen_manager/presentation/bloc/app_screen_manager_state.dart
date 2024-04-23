part of 'app_screen_manager_bloc.dart';

enum AppScreenManagerStatus {
  close,
  open,
}

class AppScreenManagerState extends Equatable {
  const AppScreenManagerState({
    this.status = AppScreenManagerStatus.close,
    this.currentOpenWindow,
  });

  final AppScreenManagerStatus status;
  final String? currentOpenWindow;

  AppScreenManagerState copyWith({
    AppScreenManagerStatus Function()? status,
    String? Function()? currentOpenWindow,
  }) {
    return AppScreenManagerState(
      status: status != null ? status() : this.status,
      currentOpenWindow: currentOpenWindow != null
          ? currentOpenWindow()
          : this.currentOpenWindow,
    );
  }

  @override
  List<Object?> get props => [status, currentOpenWindow];
}
