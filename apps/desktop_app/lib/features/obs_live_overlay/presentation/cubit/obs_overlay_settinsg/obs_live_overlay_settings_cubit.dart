import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_scripture/shared/domain/repositories/settings_repository.dart';

import '../../../domain/entities/overlay_settings.dart';

part 'obs_live_overlay_settings_state.dart';

class ObsLiveOverlaySettingsCubit extends Cubit<ObsLiveOverlaySettingsState> {
  ObsLiveOverlaySettingsCubit({required this.repo})
      : super(ObsLiveOverlaySettingsState()) {
    loadSettings();
  }

  final SettingsRepository<OverlaySettings> repo;

  Timer? _saveDebounce;

  void loadSettings() {
    repo.loadSettings().then((either) => either.fold(
          (l) => print('no settings found'),
          (r) => emit(state.copyWith(settings: r)),
        ));
  }

  void updateSettings(OverlaySettings Function(OverlaySettings) settings) {
    emit(state.copyWith(settings: settings(state.settings)));
    _scheduleSave();
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
