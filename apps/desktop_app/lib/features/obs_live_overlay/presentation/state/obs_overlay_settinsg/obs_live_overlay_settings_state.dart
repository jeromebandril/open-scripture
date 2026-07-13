part of 'obs_live_overlay_settings_cubit.dart';

class ObsLiveOverlaySettingsState extends Equatable {
  const ObsLiveOverlaySettingsState({
    this.settings = const OverlaySettings(),
  });

  final OverlaySettings settings;

  String get url => 'http://localhost:${settings.port}/overlay';

  ObsLiveOverlaySettingsState copyWith({
    OverlaySettings? settings,
  }) {
    return ObsLiveOverlaySettingsState(
      settings: settings ?? this.settings,
    );
  }

  @override
  List<Object> get props => [settings];
}
