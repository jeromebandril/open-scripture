import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_scripture/core/engines/settings/settings_repository.dart';
import 'package:open_scripture/features/bible_importer/domain/entities/bible_importer_settings.dart';

part 'bible_importer_settings_state.dart';

class BibleImporterSettingsCubit extends Cubit<BibleImporterSettingsState> {
  final SettingsRepository<BibleImporterSettings> _repo;

  BibleImporterSettingsCubit(
      {required SettingsRepository<BibleImporterSettings> repo})
      : _repo = repo,
        super(BibleImporterSettingsState());

  Timer? _saveDebounce;

  void updateSettings(
      BibleImporterSettings Function(BibleImporterSettings) settings) {
    emit(BibleImporterSettingsState(settings: settings(state.settings)));
    _scheduleSave();
  }

  void loadSettings() {
    _repo.loadSettings().then((either) => either.fold(
          (l) => print('no settings found'),
          (r) => emit(BibleImporterSettingsState(settings: r)),
        ));
  }

  void saveSettings() {
    _repo.saveSettings(state.settings).then((either) => either.fold(
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
