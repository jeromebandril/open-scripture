part of 'sword_engine_settings_cubit.dart';

enum SwordEngineSettingsStatus {
  init,
  ready,
  error,
  loading,
}

final class SwordEngineSettingsState extends Equatable {
  const SwordEngineSettingsState({
    this.settings = const SwordEngineSettings(modulesPath: ''),
    this.error,
    this.status = SwordEngineSettingsStatus.init,
  });

  final SwordEngineSettings settings;
  final String? error;
  final SwordEngineSettingsStatus status;

  SwordEngineSettingsState copyWith({
    SwordEngineSettings? settings,
    String? Function()? error,
    SwordEngineSettingsStatus? status,
  }) {
    return SwordEngineSettingsState(
      settings: settings ?? this.settings,
      error: error != null ? error() : this.error,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [settings, error, status];
}
