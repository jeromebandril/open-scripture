import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_smyrna_bible_v2/features/customizer/domain/repo/customizer_repo.dart';

import '../../domain/entities/app_theme.dart';
import '../../domain/entities/bible_pane_theme.dart';

part 'customizer_state.dart';

class CustomizerCubit extends Cubit<CustomizerState> {
  CustomizerCubit({
    required this.repo,
  }) : super(CustomizerState()) {
    // always load initial theme
    loadTheme();
  }

  final CustomizerRepo repo;

  void loadTheme() async {
    final eitherFailureOrTheme = await repo.loadTheme();

    eitherFailureOrTheme.fold(
      (f) => print('no theme found'),
      (theme) => emit(theme),
    );
  }

  void saveTheme(CustomizerState theme) async {
    final eitherFailOrSuccess = await repo.saveTheme(theme);

    eitherFailOrSuccess.fold((f) => print('errore!'), (_) {});
  }

  void updateTheme({
    BiblePaneThemeSettings Function(BiblePaneThemeSettings)? paneTheme,
    AppThemeSettings Function(AppThemeSettings)? appTheme,
  }) {
    emit(state.copyWith(
      app: appTheme?.call(state.app),
      pane: paneTheme?.call(state.pane),
    ));
  }
}
