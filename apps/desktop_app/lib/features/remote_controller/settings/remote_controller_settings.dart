import 'package:equatable/equatable.dart';

class RemoteControllerSettings extends Equatable {
  final int port;
  final bool enableFeature;

  const RemoteControllerSettings({
    this.port = 50150,
    this.enableFeature = false,
  });

  RemoteControllerSettings copyWith({
    int? port,
    bool? enableFeature,
  }) {
    return RemoteControllerSettings(
      port: port ?? this.port,
      enableFeature: enableFeature ?? this.enableFeature,
    );
  }

  Map<String, dynamic> toJson() => {
        'port': port,
        'enableFeature': enableFeature,
      };

  static RemoteControllerSettings fromJson(Map<String, dynamic> json) {
    final defaults = RemoteControllerSettings();

    return RemoteControllerSettings(
      port: json['port'] as int? ?? defaults.port,
      enableFeature: json['enableFeature'] as bool? ?? defaults.enableFeature,
    );
  }

  @override
  List<Object?> get props => [port, enableFeature];
}
