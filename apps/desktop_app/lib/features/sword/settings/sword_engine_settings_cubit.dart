import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/engines/settings/settings_repository.dart';
import '../../../shared/data/services/sword_service.dart';
import 'sword_engine_settings.dart';

part 'sword_engine_settings_state.dart';

class SwordEngineSettingsCubit extends Cubit<SwordEngineSettingsState> {
  final SettingsRepository<SwordEngineSettings> _repo;
  final SwordService _swordService;

  SwordEngineSettingsCubit({
    required SettingsRepository<SwordEngineSettings> repo,
    required SwordService swordService,
  })  : _swordService = swordService,
        _repo = repo,
        super(SwordEngineSettingsState());

  void loadSettings() {
    _repo.loadSettings().then((result) {
      result.fold(
          // TODO: on error I should emit error and show a warning message
          (failure) => emit(state.copyWith(
                status: SwordEngineSettingsStatus.error,
              )),
          (settings) => emit(state.copyWith(
                settings: settings,
                status: SwordEngineSettingsStatus.ready,
              )));
    });
  }

  Future<void> updateInstallationPath(String newPath) async {
    emit(state.copyWith(status: SwordEngineSettingsStatus.loading));

    final update = state.settings.copyWith(modulesPath: newPath);
    final result = await _repo.saveSettings(update);

    result.fold(
      (f) => emit(state.copyWith(
        status: SwordEngineSettingsStatus.error,
      )),
      (_) {
        emit(state.copyWith(
          settings: update,
          status: SwordEngineSettingsStatus.ready,
        ));
        _swordService.restart().then((_) {}).catchError((e) {
          emit(state.copyWith(
            status: SwordEngineSettingsStatus.error,
            error: () => e.toString(),
          ));
        });
      },
    );
  }
}
