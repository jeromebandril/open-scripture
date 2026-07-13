part of 'remote_controller_settings_cubit.dart';

class RemoteControllerSettingsState extends Equatable {
  final RemoteControllerSettings settings;

  const RemoteControllerSettingsState({
    this.settings = const RemoteControllerSettings(),
  });

  @override
  List<Object?> get props => [settings];
}
