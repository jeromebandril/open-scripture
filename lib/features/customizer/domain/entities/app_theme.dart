import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:the_smyrna_bible_v2/core/utils/colors_util.dart';

/// App-wide theme settings that affect MaterialApp.

enum SearchbarPosition { left, center }

class AppThemeSettings extends Equatable {
  final ThemeMode mode;
  final String fontFamily;
  final Color accentColor;
  final bool enableAutoColorScheme;
  final SearchbarPosition searchbarPosition;
  final bool enableDynamicSearchbar;

  const AppThemeSettings({
    this.mode = ThemeMode.system,
    this.fontFamily = 'General Sans',
    this.accentColor = Colors.blue,
    this.enableAutoColorScheme = true,
    this.searchbarPosition = SearchbarPosition.left,
    this.enableDynamicSearchbar = false,
  });

  AppThemeSettings copyWith({
    ThemeMode? mode,
    String? fontFamily,
    Color? accentColor,
    bool? enableAutoColorScheme,
    bool? enableCustomTheme,
    SearchbarPosition? searchbarPosition,
    bool? enableDynamicSearchbar,
  }) {
    return AppThemeSettings(
      mode: mode ?? this.mode,
      fontFamily: fontFamily ?? this.fontFamily,
      accentColor: accentColor ?? this.accentColor,
      enableAutoColorScheme:
          enableAutoColorScheme ?? this.enableAutoColorScheme,
      searchbarPosition: searchbarPosition ?? this.searchbarPosition,
      enableDynamicSearchbar:
          enableDynamicSearchbar ?? this.enableDynamicSearchbar,
    );
  }

  @override
  List<Object?> get props => [
        mode,
        fontFamily,
        accentColor,
        enableAutoColorScheme,
        searchbarPosition,
        enableDynamicSearchbar,
      ];

  Map<String, dynamic> toJson() => {
        'mode': mode.name,
        'fontFamily': fontFamily,
        'accentColor': ColorsUtil.colorToHex(accentColor),
        'enableAutoColorScheme': enableAutoColorScheme,
        'searchbarPosition': searchbarPosition.toString(),
        'enableDynamicSearchbar': enableDynamicSearchbar,
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

    SearchbarPosition parseSearchbarPosition(String? p) {
      switch (p) {
        case 'SearchbarPosition.center':
          return SearchbarPosition.center;
        default:
          return SearchbarPosition.left;
      }
    }

    return AppThemeSettings(
      mode: parseMode(json['mode'] as String),
      fontFamily: json['fontFamily'] as String,
      accentColor: Color(ColorsUtil.parseHex(json['accentColor'] as String)),
      enableAutoColorScheme: json['enableAutoColorScheme'] as bool,
      searchbarPosition:
          parseSearchbarPosition(json['searchbarPosition'] as String),
      enableDynamicSearchbar: json['enableDynamicSearchbar'] as bool,
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
                primary: Color(0xFF3B6EDC), // muted blue
                onPrimary: Color(0xFFF7F7F7),

                primaryContainer: Color(0xFFD9E4FF),
                onPrimaryContainer: Color(0xFF0E1A2A),

                // Neutral support
                secondary: Color(0xFF5E5E5E),
                onSecondary: Color(0xFFF7F7F7),

                tertiary: Color(0xFF707070),
                onTertiary: Color(0xFFF7F7F7),

                surface: Color(0xFFF7F7F7),
                onSurface: Color(0xFF121212),

                surfaceContainerLowest: Color(0xFFFFFFFF),
                surfaceContainerLow: Color(0xFFF2F2F2),
                surfaceContainer: Color(0xFFEDEDED),
                surfaceContainerHighest: Color(0xFFE4E4E4),
                surfaceContainerHigh: Color(0xFFE8E8E8),
                onSurfaceVariant: Color(0xFF3A3A3A),

                // Borders & dividers
                outline: Color(0xFF8A8A8A),
                outlineVariant: Color(0xFFC9C9C9),

                // Feedback
                error: Color(0xFFB3261E),
                onError: Color(0xFFF7F7F7),

                // Inverse (snackbars, etc.)
                inverseSurface: Color(0xFF1A1A1A),
                onInverseSurface: Color(0xFFEDEDED),
                inversePrimary: Color(0xFF8AB4F8),

                // Misc
                shadow: Color(0xFF000000),
                scrim: Color(0xFF000000),
              )
            : ColorScheme.dark(
                // ACCENT (active controls)
                primary: Color(0xFF8AB4F8), // muted blue-gray
                onPrimary: Color(0xFF0E1A2A),

                primaryContainer: Color(0xFF1E2A3A),
                onPrimaryContainer: Color(0xFFDCE6F3),

                // Neutral support
                secondary: Color(0xFFBDBDBD),
                onSecondary: Color(0xFF121212),

                tertiary: Color(0xFF9E9E9E),
                onTertiary: Color(0xFF121212),

                // Backgrounds & surfaces

                surface: Color(0xFF1A1A1A),
                onSurface: Color(0xFFE6E6E6),

                surfaceContainerLowest: Color(0xFF141414),
                surfaceContainerLow: Color(0xFF1E1E1E),
                surfaceContainer: Color(0xFF222222),
                surfaceContainerHigh: Color(0xFF242424),
                surfaceContainerHighest: Color(0xFF2A2A2A),
                onSurfaceVariant: Color(0xFFBDBDBD),

                // Borders & dividers
                outline: Color(0xFF6A6A6A),
                outlineVariant: Color.fromARGB(255, 69, 69, 69),

                // Feedback
                error: Color(0xFFCF6679),
                onError: Color(0xFF121212),

                // Inverse
                inverseSurface: Color(0xFFE6E6E6),
                onInverseSurface: Color(0xFF121212),
                inversePrimary: Color(0xFF1E2A3A),

                // Misc
                shadow: Color(0xFF000000),
                scrim: Color(0xFF000000),
              );
  }
}
