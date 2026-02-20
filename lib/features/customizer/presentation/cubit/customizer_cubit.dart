import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_scripture/features/customizer/domain/entities/bible_pane_presentation_theme_settings.dart';
import 'package:open_scripture/features/customizer/domain/entities/bible_view_list_theme_settings.dart';
import 'package:open_scripture/shared/domain/repositories/settings_repository.dart';

import '../../domain/entities/app_theme_settings.dart';
import '../../domain/entities/bible_pane_general_theme_settings.dart';

part 'customizer_state.dart';

class CustomizerCubit extends Cubit<CustomizerState> {
  CustomizerCubit({
    required this.repo,
  }) : super(CustomizerState()) {
    // always load initial theme
    loadTheme();
  }

  final SettingsRepository<CustomizerState> repo;
  Timer? _saveDebounce;

  void loadTheme() async {
    final eitherFailureOrTheme = await repo.loadSettings();
    eitherFailureOrTheme.fold(
      (f) => print('no theme found'),
      (theme) => emit(theme),
    );
  }

  void saveTheme() async {
    final eitherFailOrSuccess = await repo.saveSettings(state);

    eitherFailOrSuccess.fold((f) => print('errore!'), (_) {
      print("save succeded");
    });
  }

  void updateTheme({
    BiblePaneGeneralThemeSettings Function(BiblePaneGeneralThemeSettings)?
        paneTheme,
    AppThemeSettings Function(AppThemeSettings)? appTheme,
    BibleViewPresentationThemeSettings Function(
            BibleViewPresentationThemeSettings)?
        presentTheme,
    BibleViewListThemeSettings Function(BibleViewListThemeSettings)? listTheme,
  }) {
    emit(state.copyWith(
      app: appTheme?.call(state.app),
      pane: paneTheme?.call(state.pane),
      presentationTheme: presentTheme?.call(state.presentTheme),
      listTheme: listTheme?.call(state.listTheme),
    ));
    _scheduleSave();
  }

  void _scheduleSave() {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(seconds: 30), saveTheme);
  }

  @override
  Future<void> close() {
    _saveDebounce?.cancel();
    return super.close();
  }
}
