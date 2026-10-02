import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class GlobalSettings extends Equatable {
  final ThemeMode mode;
  final bool enableAutoColorScheme;
  final bool enable3TapNavigator;
  final bool enableAdaptiveTitlebar;
  final bool collapseSearchbarToIcon;

  const GlobalSettings({
    this.mode = ThemeMode.light,
    this.enableAutoColorScheme = true,
    this.enable3TapNavigator = false,
    this.enableAdaptiveTitlebar = false,
    this.collapseSearchbarToIcon = false,
  });

  GlobalSettings copyWith({
    ThemeMode? mode,
    // String? fontFamily,
    // Color? accentColor,
    bool? enableAutoColorScheme,
    // bool? enableCustomTheme,
    bool? enable3TapNavigator,
    bool? enableAdaptiveTitlebar,
    bool? collapseSearchbarToIcon,
  }) {
    return GlobalSettings(
      mode: mode ?? this.mode,
      enableAutoColorScheme:
          enableAutoColorScheme ?? this.enableAutoColorScheme,
      enable3TapNavigator: enable3TapNavigator ?? this.enable3TapNavigator,
      enableAdaptiveTitlebar:
          enableAdaptiveTitlebar ?? this.enableAdaptiveTitlebar,
      collapseSearchbarToIcon:
          collapseSearchbarToIcon ?? this.collapseSearchbarToIcon,
    );
  }

  @override
  List<Object?> get props => [
        mode,
        enableAutoColorScheme,
        enable3TapNavigator,
        enableAdaptiveTitlebar,
        collapseSearchbarToIcon,
      ];

  Map<String, dynamic> toJson() => {
        'mode': mode.name,
        'enableAutoColorScheme': enableAutoColorScheme,
        'enable3TapNavigator': enable3TapNavigator,
        'enableAdaptiveTitlebar': enableAdaptiveTitlebar,
        'collapseSearchbarToIcon': collapseSearchbarToIcon,
      };

  static GlobalSettings fromJson(Map<String, dynamic> json) {
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

    return GlobalSettings(
      mode: parseMode(json['mode'] as String),
      enableAutoColorScheme: json['enableAutoColorScheme'] as bool,
      enable3TapNavigator: json['enable3TapNavigator'] as bool,
      enableAdaptiveTitlebar: json['enableAdaptiveTitlebar'] as bool,
      collapseSearchbarToIcon: json['collapseSearchbarToIcon'] as bool,
    );
  }
}
