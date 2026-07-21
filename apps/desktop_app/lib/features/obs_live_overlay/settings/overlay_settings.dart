import 'package:equatable/equatable.dart';

class OverlaySettings extends Equatable {
  final int port;
  final bool enableFeature;
  final bool enableAutoStart;
  final bool enableManualControl;
  final int hideDebounceSeconds;

  const OverlaySettings({
    this.port = 17890,
    this.enableFeature = true,
    this.enableAutoStart = false,
    this.enableManualControl = false,
    this.hideDebounceSeconds = 30,
  });

  String get url => 'http://localhost:$port/overlay';

  OverlaySettings copyWith({
    int? port,
    bool? enableFeature,
    bool? enableAutoStart,
    bool? enableManualControl,
    int? hideDebounceSeconds,
  }) {
    return OverlaySettings(
      port: port ?? this.port,
      enableFeature: enableFeature ?? this.enableFeature,
      enableAutoStart: enableAutoStart ?? this.enableAutoStart,
      enableManualControl: enableManualControl ?? this.enableManualControl,
      hideDebounceSeconds: hideDebounceSeconds ?? this.hideDebounceSeconds,
    );
  }

  Map<String, dynamic> toJson() => {
        'port': port,
        'enableFeature': enableFeature,
        'enableAutoStart': enableAutoStart,
        'enableManualControl': enableManualControl,
        'hideDebounceSeconds': hideDebounceSeconds,
      };

  static OverlaySettings fromJson(Map<String, dynamic> json) => OverlaySettings(
        port: json['port'] as int,
        enableFeature: json['enableFeature'] as bool,
        enableAutoStart: json['enableAutoStart'] as bool,
        enableManualControl: json['enableManualControl'] as bool,
        hideDebounceSeconds: json['hideDebounceSeconds'] as int,
      );

  @override
  List<Object?> get props => [
        port,
        enableFeature,
        enableAutoStart,
        enableManualControl,
        hideDebounceSeconds,
      ];
}
