import 'package:equatable/equatable.dart';

class OverlaySettings extends Equatable {
  final int port;
  final bool enableFeature;
  final bool enableAutoStart;
  final bool enableManualControl;

  const OverlaySettings({
    this.port = 17890,
    this.enableFeature = true,
    this.enableAutoStart = false,
    this.enableManualControl = false,
  });

  OverlaySettings copyWith({
    int? port,
    bool? enableFeature,
    bool? enableAutoStart,
    bool? enableManualControl,
  }) {
    return OverlaySettings(
      port: port ?? this.port,
      enableFeature: enableFeature ?? this.enableFeature,
      enableAutoStart: enableAutoStart ?? this.enableAutoStart,
      enableManualControl: enableManualControl ?? this.enableManualControl,
    );
  }

  Map<String, dynamic> toJson() => {
        'port': port,
        'enableFeature': enableFeature,
        'enableAutoStart': enableAutoStart,
        'enableManualControl': enableManualControl,
      };

  static OverlaySettings fromJson(Map<String, dynamic> json) => OverlaySettings(
        port: json['port'] as int,
        enableFeature: json['enableFeature'] as bool,
        enableAutoStart: json['enableAutoStart'] as bool,
        enableManualControl: json['enableManualControl'] as bool,
      );

  @override
  List<Object?> get props => [
        port,
        enableFeature,
        enableAutoStart,
        enableManualControl,
      ];
}
