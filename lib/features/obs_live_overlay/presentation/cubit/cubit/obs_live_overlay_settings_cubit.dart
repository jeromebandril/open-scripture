import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'obs_live_overlay_settings_state.dart';

class ObsLiveOverlaySettingsCubit extends Cubit<ObsLiveOverlaySettingsState> {
  ObsLiveOverlaySettingsCubit() : super(ObsLiveOverlaySettingsState());

  void setPort(int port) {
    emit(state.copyWith(port: port));
  }

  void setEnabled(bool enabled) {
    emit(state.copyWith(enableFeature: enabled));
  }
}
