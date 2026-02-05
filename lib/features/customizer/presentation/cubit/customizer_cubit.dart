import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_smyrna_bible_v2/features/customizer/domain/repo/customizer_repo.dart';

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

  final CustomizerRepo repo;
  Timer? _saveDebounce;

  void loadTheme() async {
    final eitherFailureOrTheme = await repo.loadTheme();

    eitherFailureOrTheme.fold(
      (f) => print('no theme found'),
      (theme) => emit(theme),
    );
  }

  void saveTheme() async {
    final eitherFailOrSuccess = await repo.saveTheme(state);

    eitherFailOrSuccess.fold((f) => print('errore!'), (_) {
      print("save succeded");
    });
  }

  void updateTheme({
    BiblePaneGeneralThemeSettings Function(BiblePaneGeneralThemeSettings)?
        paneTheme,
    AppThemeSettings Function(AppThemeSettings)? appTheme,
  }) {
    emit(state.copyWith(
      app: appTheme?.call(state.app),
      pane: paneTheme?.call(state.pane),
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
