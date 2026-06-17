import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_scripture/features/bible_importer/domain/entities/bible_importer_settings.dart';
import 'package:open_scripture/shared/domain/services/bible_importer_settings_service.dart';

part 'bible_importer_settings_state.dart';

class BibleImporterSettingsCubit extends Cubit<BibleImporterSettingsState> {
  final BibleImporterSettingsService _settingsService;

  BibleImporterSettingsCubit(
      {required BibleImporterSettingsService settingsService})
      : _settingsService = settingsService,
        super(BibleImporterSettingsState());

  void loadSettings() {
    emit(state.copyWith(
      settings: _settingsService.current,
      status: BibleImporterSettingsStatus.ready,
    ));
  }

  Future<void> updateInstallationPath(String newPath) async {
    emit(state.copyWith(status: BibleImporterSettingsStatus.loading));

    final result = await _settingsService.updatePath(newPath);

    result.fold(
        (f) => emit(state.copyWith(
              status: BibleImporterSettingsStatus.error,
            )),
        (_) => emit(state.copyWith(
              settings: _settingsService.current,
              status: BibleImporterSettingsStatus.ready,
            )));
  }

  @override
  Future<void> close() async {
    await super.close();
  }
}
