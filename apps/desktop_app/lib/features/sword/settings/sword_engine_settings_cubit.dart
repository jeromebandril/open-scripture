import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/engines/settings/settings_repository.dart';
import '../../../shared/data/services/sword_service.dart';
import 'sword_engine_settings.dart';

part 'sword_engine_settings_state.dart';

class SwordEngineSettingsCubit extends Cubit<SwordEngineSettingsState> {
  SwordEngineSettingsCubit({
    required SettingsRepository<SwordEngineSettings> repo,
    required SwordService swordService,
  })  : _repo = repo,
        _swordService = swordService,
        super(SwordEngineSettingsState(
          settings: repo.current,
          status: SwordEngineSettingsStatus.ready,
        )) {
    _sub = repo.changes.listen((settings) {
      emit(state.copyWith(settings: settings));
    });
  }

  final SettingsRepository<SwordEngineSettings> _repo;
  final SwordService _swordService;
  late final StreamSubscription<SwordEngineSettings> _sub;

  Future<void> updateInstallationPath(String newPath) async {
    emit(state.copyWith(status: SwordEngineSettingsStatus.loading));

    final update = state.settings.copyWith(modulesPath: newPath);
    final result = await _repo.saveSettings(update);

    await result.fold(
      (f) async =>
          emit(state.copyWith(status: SwordEngineSettingsStatus.error)),
      (_) async {
        emit(state.copyWith(
          settings: update,
          status: SwordEngineSettingsStatus.ready,
        ));
        try {
          await _swordService.restart();
        } catch (e) {
          emit(state.copyWith(
            status: SwordEngineSettingsStatus.error,
            error: () => e.toString(),
          ));
        }
      },
    );
  }

  Future<void> reload() async {
    final result = await _repo.loadSettings();
    result.fold(
      (f) => emit(state.copyWith(status: SwordEngineSettingsStatus.error)),
      (_) {},
    );
  }

  @override
  Future<void> close() async {
    await _sub.cancel();
    await _repo.flush();
    await super.close();
  }
}
