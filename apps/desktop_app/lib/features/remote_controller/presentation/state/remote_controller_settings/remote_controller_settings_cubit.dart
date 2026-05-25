import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_scripture/features/remote_controller/domain/entities/remote_controller_settings.dart';

import '../../../../../core/engines/settings/settings_repository.dart';

part 'remote_controller_settings_state.dart';

class RemoteControllerSettingsCubit
    extends Cubit<RemoteControllerSettingsState> {
  RemoteControllerSettingsCubit({required this.repo})
      : super(RemoteControllerSettingsState()) {
    loadSettings();
  }

  final SettingsRepository<RemoteControllerSettings> repo;

  Timer? _saveDebounce;

  void updateSettings(
      RemoteControllerSettings Function(RemoteControllerSettings) settings) {
    emit(RemoteControllerSettingsState(settings: settings(state.settings)));
    _scheduleSave();
  }

  void loadSettings() {
    repo.loadSettings().then((either) => either.fold(
          (l) => print('no settings found'),
          (r) => emit(RemoteControllerSettingsState(settings: r)),
        ));
  }

  void saveSettings() {
    repo.saveSettings(state.settings).then((either) => either.fold(
          (l) => print('error saving settings'),
          (r) => print('settings saved'),
        ));
  }

  void _scheduleSave() {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(seconds: 30), saveSettings);
  }

  @override
  Future<void> close() async {
    _saveDebounce?.cancel();
    saveSettings();
    await super.close();
  }
}
