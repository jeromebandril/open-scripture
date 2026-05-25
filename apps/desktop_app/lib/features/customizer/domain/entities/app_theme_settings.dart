import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:open_scripture/shared/utils/colors_util.dart';

/// App-wide theme settings that affect MaterialApp.

class AppThemeSettings extends Equatable {
  final ThemeMode mode;
  final String fontFamily;
  final Color accentColor;
  final bool enableAutoColorScheme;
  final bool enable3TapNavigator;

  const AppThemeSettings({
    this.mode = ThemeMode.system,
    this.fontFamily = 'General Sans',
    this.accentColor = Colors.blue,
    this.enableAutoColorScheme = true,
    this.enable3TapNavigator = false,
  });

  AppThemeSettings copyWith(
      {ThemeMode? mode,
      String? fontFamily,
      Color? accentColor,
      bool? enableAutoColorScheme,
      bool? enableCustomTheme,
      bool? enableDynamicInterface,
      bool? enable3TapNavigator}) {
    return AppThemeSettings(
      mode: mode ?? this.mode,
      fontFamily: fontFamily ?? this.fontFamily,
      accentColor: accentColor ?? this.accentColor,
      enableAutoColorScheme:
          enableAutoColorScheme ?? this.enableAutoColorScheme,
      enable3TapNavigator: enable3TapNavigator ?? this.enable3TapNavigator,
    );
  }

  @override
  List<Object?> get props => [
        mode,
        fontFamily,
        accentColor,
        enableAutoColorScheme,
        enable3TapNavigator,
      ];

  Map<String, dynamic> toJson() => {
        'mode': mode.name,
        'fontFamily': fontFamily,
        'accentColor': ColorsUtil.colorToHex(accentColor),
        'enableAutoColorScheme': enableAutoColorScheme,
        'enable3TapNavigator': enable3TapNavigator,
      };

  static AppThemeSettings fromJson(Map<String, dynamic> json) {
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

    return AppThemeSettings(
      mode: parseMode(json['mode'] as String),
      fontFamily: json['fontFamily'] as String,
      accentColor: Color(ColorsUtil.parseHex(json['accentColor'] as String)),
      enableAutoColorScheme: json['enableAutoColorScheme'] as bool,
      enable3TapNavigator: json['enable3TapNavigator'] as bool,
    );
  }
}

/// Builds ThemeData for your MaterialApp.
class AppThemeBuilder {
  const AppThemeBuilder();

  ThemeData buildLight(AppThemeSettings s) {
    final cs = _colorScheme(Brightness.light, s);
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: cs,
      useMaterial3: true,
      fontFamily: s.fontFamily,
    );
  }

  ThemeData buildDark(AppThemeSettings s) {
    final cs = _colorScheme(Brightness.dark, s);
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: cs,
      useMaterial3: true,
      fontFamily: s.fontFamily,
    );
  }

  ColorScheme _colorScheme(Brightness brightness, AppThemeSettings s) {
    final seed = s.accentColor;

    return s.enableAutoColorScheme
        ? ColorScheme.fromSeed(
            seedColor: seed,
            brightness: brightness,
          )
        // CHANGE HERE FOR DEFAULT COLORSCHEMES
        : brightness == Brightness.light
            ? ColorScheme.light(
                brightness: brightness,
                // ACCENT (active controls)
                primary: Color(0xFF2558C0), // deeper, more saturated blue
                onPrimary: Color(0xFFF8F8F8),
                primaryContainer: Color(0xFFD9E4FF),
                onPrimaryContainer: Color(0xFF0C1A2E),

                // Neutral support
                secondary: Color(0xFF5A5A5A),
                onSecondary: Color(0xFFF8F8F8),
                tertiary: Color(0xFF6E6E6E),
                onTertiary: Color(0xFFF8F8F8),

                // Backgrounds & surfaces — warmer whites, more distinct steps
                surface: Color(0xFFF4F4F4),
                onSurface: Color(0xFF141414),
                surfaceContainerLowest: Color(0xFFFFFFFF),
                surfaceContainerLow: Color(0xFFF9F9F9),
                surfaceContainer: Color(0xFFF0F0F0),
                surfaceContainerHigh: Color(0xFFE8E8E8),
                surfaceContainerHighest: Color(0xFFE0E0E0),
                onSurfaceVariant: Color(0xFF3A3A3A),

                // Borders & dividers
                outline: Color(0xFF8A8A8A),
                outlineVariant: Color(0xFFCCCCCC),

                // Feedback
                error: Color(0xFFB3261E),
                onError: Color(0xFFF8F8F8),

                // Inverse (snackbars, etc.)
                inverseSurface: Color(0xFF1A1A1A),
                onInverseSurface: Color(0xFFECECEC),
                inversePrimary: Color(0xFF7BAEF5), // matches dark mode primary

                // Misc
                shadow: Color(0xFF000000),
                scrim: Color(0xFF000000),
              )
            : ColorScheme.dark(
                // ACCENT (active controls)
                primary: Color(0xFF7BAEF5), // slightly deeper, richer blue
                onPrimary: Color(0xFF0A1828),
                primaryContainer: Color(0xFF1A2535),
                onPrimaryContainer: Color(0xFFB8D0F0),

                // Neutral support
                secondary: Color(0xFFA8A8A8),
                onSecondary: Color(0xFF0D0D0D),
                tertiary: Color(0xFF888888),
                onTertiary: Color(0xFF0D0D0D),

                // Backgrounds & surfaces — all pushed darker
                surface: Color(0xFF181818),
                onSurface: Color(0xFFEBEBEB),
                surfaceContainerLowest: Color(0xFF0C0C0C),
                surfaceContainerLow: Color(0xFF141414),
                surfaceContainer: Color(0xFF181818),
                surfaceContainerHigh: Color(0xFF1C1C1C),
                surfaceContainerHighest: Color(0xFF212121),
                onSurfaceVariant: Color(0xFFA0A0A0),

                // Borders & dividers
                outline: Color(0xFF505050),
                outlineVariant: Color(0xFF333333),

                // Feedback
                error: Color(0xFFCF6679),
                onError: Color(0xFF0D0D0D),

                // Inverse
                inverseSurface: Color(0xFFEBEBEB),
                onInverseSurface: Color(0xFF101010),
                inversePrimary: Color(0xFF1A2535),

                // Misc
                shadow: Color(0xFF000000),
                scrim: Color(0xFF000000),
              );
  }
}
