import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppSettings extends Equatable {
  final ThemeMode mode;
  final bool enableAutoColorScheme;
  final bool enable3TapNavigator;
  final bool enableAdaptiveTitlebar;

  const AppSettings({
    this.mode = ThemeMode.light,
    this.enableAutoColorScheme = true,
    this.enable3TapNavigator = false,
    this.enableAdaptiveTitlebar = false,
  });

  AppSettings copyWith({
    ThemeMode? mode,
    // String? fontFamily,
    // Color? accentColor,
    bool? enableAutoColorScheme,
    // bool? enableCustomTheme,
    bool? enable3TapNavigator,
    bool? enableAdaptiveTitlebar,
  }) {
    return AppSettings(
      mode: mode ?? this.mode,
      enableAutoColorScheme:
          enableAutoColorScheme ?? this.enableAutoColorScheme,
      enable3TapNavigator: enable3TapNavigator ?? this.enable3TapNavigator,
      enableAdaptiveTitlebar:
          enableAdaptiveTitlebar ?? this.enableAdaptiveTitlebar,
    );
  }

  @override
  List<Object?> get props => [
        mode,
        enableAutoColorScheme,
        enable3TapNavigator,
        enableAdaptiveTitlebar,
      ];

  Map<String, dynamic> toJson() => {
        'mode': mode.name,
        'enableAutoColorScheme': enableAutoColorScheme,
        'enable3TapNavigator': enable3TapNavigator,
        'enableAdaptiveTitlebar': enableAdaptiveTitlebar,
      };

  static AppSettings fromJson(Map<String, dynamic> json) {
    ThemeMode parseMode(String? s) {
      switch (s) {
        case 'dark':
          return ThemeMode.dark;
        case 'light':
          return ThemeMode.light;
        default:
          return ThemeMode.system;
      }
    }

    return AppSettings(
      mode: parseMode(json['mode'] as String),
      enableAutoColorScheme: json['enableAutoColorScheme'] as bool,
      enable3TapNavigator: json['enable3TapNavigator'] as bool,
      enableAdaptiveTitlebar: json['enableAdaptiveTitlebar'] as bool,
    );
  }
}
