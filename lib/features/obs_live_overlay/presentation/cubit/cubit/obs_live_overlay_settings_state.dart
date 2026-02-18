part of 'obs_live_overlay_settings_cubit.dart';

class ObsLiveOverlaySettingsState extends Equatable {
  const ObsLiveOverlaySettingsState({
    this.enableFeature = true,
    this.port = 17890,
  });

  final bool enableFeature;
  final int port;

  String get url => 'http://localhost:$port/overlay';

  ObsLiveOverlaySettingsState copyWith({
    bool? enableFeature,
    int? port,
  }) {
    return ObsLiveOverlaySettingsState(
      enableFeature: enableFeature ?? this.enableFeature,
      port: port ?? this.port,
    );
  }

  @override
  List<Object> get props => [enableFeature, port];
}
