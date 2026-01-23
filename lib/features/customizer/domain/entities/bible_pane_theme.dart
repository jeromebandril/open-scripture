import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:the_smyrna_bible_v2/core/utils/colors_util.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_pane/presentation/widgets/parts/verse_widget.dart';

class BiblePaneThemeSettings extends Equatable {
  final String fontFamily;
  final double fontSize;
  final Color textColor;
  final Color backgroundColor;
  final bool showVerseDivider;
  final bool showFullRefAlways;
  final Color accentColor;
  final Color refColor;
  final bool enableCustomTheme;
  final HighlightRenderMode highlightRenderMode;
  final FontWeight textFontWeight;
  final double widthAdjustmentOffset;
  // final bool useAdjustWidthOffsetForWholeApp;

  const BiblePaneThemeSettings({
    this.fontFamily = 'General Sans',
    this.fontSize = 14,
    this.textColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.showVerseDivider = false,
    this.showFullRefAlways = false,
    this.accentColor = Colors.blue,
    this.refColor = Colors.black,
    this.enableCustomTheme = false,
    this.highlightRenderMode = HighlightRenderMode.fullRefWithColor,
    this.textFontWeight = FontWeight.w400,
    this.widthAdjustmentOffset = 0.0,
  });

  BiblePaneThemeSettings copyWith({
    String? fontFamily,
    double? fontSize,
    Color? textColor,
    Color? backgroundColor,
    bool? showVerseDivider,
    bool? showFullRefAlways,
    Color? accentColor,
    Color? refColor,
    bool? enableCustomTheme,
    HighlightRenderMode? highlightRenderMode,
    FontWeight? textFontWeight,
    double? widthAdjustmentOffset,
  }) {
    return BiblePaneThemeSettings(
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      textColor: textColor ?? this.textColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      showVerseDivider: showVerseDivider ?? this.showVerseDivider,
      showFullRefAlways: showFullRefAlways ?? this.showFullRefAlways,
      accentColor: accentColor ?? this.accentColor,
      refColor: refColor ?? this.refColor,
      enableCustomTheme: enableCustomTheme ?? this.enableCustomTheme,
      highlightRenderMode: highlightRenderMode ?? this.highlightRenderMode,
      textFontWeight: textFontWeight ?? this.textFontWeight,
      widthAdjustmentOffset:
          widthAdjustmentOffset ?? this.widthAdjustmentOffset,
    );
  }

  @override
  List<Object?> get props => [
        fontFamily,
        fontSize,
        textColor,
        backgroundColor,
        showVerseDivider,
        showFullRefAlways,
        accentColor,
        refColor,
        enableCustomTheme,
        highlightRenderMode,
        textFontWeight,
        widthAdjustmentOffset,
      ];

  Map<String, dynamic> toJson() => {
        'fontFamily': fontFamily,
        'fontSize': fontSize,
        'textColor': ColorsUtil.colorToHex(textColor),
        'backgroundColor': ColorsUtil.colorToHex(backgroundColor),
        'showVerseDivider': showVerseDivider,
        'showFullRefAlways': showFullRefAlways,
        'accentColor': ColorsUtil.colorToHex(accentColor),
        'refColor': ColorsUtil.colorToHex(refColor),
        'enableCustomTheme': enableCustomTheme,
        'highlightRenderMode': highlightRenderMode.toString(),
        'textFontWeight': textFontWeight.toString(),
        'widthAdjustmentOffset': widthAdjustmentOffset,
      };

  static BiblePaneThemeSettings fromJson(Map<String, dynamic> json) {
    HighlightRenderMode parseHighlightRenderMode(String? s) {
      switch (s) {
        case 'HighlightRenderMode.fullRefWithColor':
          return HighlightRenderMode.fullRefWithColor;
        default:
          return HighlightRenderMode.fullRefWithColor;
      }
    }

    return BiblePaneThemeSettings(
      fontFamily: json['fontFamily'] as String,
      fontSize: (json['fontSize'] as num).toDouble(),
      textColor: Color(ColorsUtil.parseHex(json['textColor'] as String)),
      backgroundColor:
          Color(ColorsUtil.parseHex(json['backgroundColor'] as String)),
      showVerseDivider: (json['showVerseDivider'] as bool),
      showFullRefAlways: (json['showFullRefAlways'] as bool),
      accentColor: Color(ColorsUtil.parseHex(json['accentColor'] as String)),
      refColor: Color(ColorsUtil.parseHex(json['refColor'] as String)),
      enableCustomTheme: (json['enableCustomTheme'] as bool),
      highlightRenderMode:
          parseHighlightRenderMode(json['highlightRenderMode'] as String),
      widthAdjustmentOffset: json['widthAdjustmentOffset'] as double,
      //textFontWeight: json['textFontWeight'],
    );
  }
}

@immutable
class BiblePaneTheme extends ThemeExtension<BiblePaneTheme> {
  final String? fontFamily;
  final double fontSize;
  final Color textColor;
  final Color backgroundColor;
  final bool showVerseDivider;
  final bool showFullRefAlways;
  final Color accentColor;
  final Color refColor;
  final bool enableCustomTheme;
  final HighlightRenderMode highlightRenderMode;
  final FontWeight textFontWeight;
  final double widthAdjustmentOffset;

  const BiblePaneTheme({
    required this.fontFamily,
    required this.fontSize,
    required this.textColor,
    required this.backgroundColor,
    required this.showVerseDivider,
    required this.showFullRefAlways,
    required this.accentColor,
    required this.refColor,
    required this.enableCustomTheme,
    required this.highlightRenderMode,
    required this.textFontWeight,
    required this.widthAdjustmentOffset,
  });

  @override
  BiblePaneTheme copyWith({
    String? fontFamily,
    double? fontSize,
    Color? textColor,
    Color? backgroundColor,
    bool? showVerseDivider,
    bool? showFullRefAlways,
    Color? accentColor,
    Color? refColor,
    bool? enableCustomTheme,
    HighlightRenderMode? highlightRenderMode,
    FontWeight? textFontWeight,
    double? widthAdjustmentOffset,
  }) {
    return BiblePaneTheme(
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      textColor: textColor ?? this.textColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      showVerseDivider: showVerseDivider ?? this.showVerseDivider,
      showFullRefAlways: showFullRefAlways ?? this.showFullRefAlways,
      accentColor: accentColor ?? this.accentColor,
      refColor: refColor ?? this.refColor,
      enableCustomTheme: enableCustomTheme ?? this.enableCustomTheme,
      highlightRenderMode: highlightRenderMode ?? this.highlightRenderMode,
      textFontWeight: textFontWeight ?? this.textFontWeight,
      widthAdjustmentOffset:
          widthAdjustmentOffset ?? this.widthAdjustmentOffset,
    );
  }

  @override
  BiblePaneTheme lerp(ThemeExtension<BiblePaneTheme>? other, double t) {
    if (other is! BiblePaneTheme) return this;
    return BiblePaneTheme(
      fontFamily: t < 0.5 ? fontFamily : other.fontFamily,
      fontSize: fontSize + (other.fontSize - fontSize) * t,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      showVerseDivider: t < 0.5 ? showVerseDivider : other.showVerseDivider,
      showFullRefAlways: t < 0.5 ? showFullRefAlways : other.showFullRefAlways,
      accentColor: Color.lerp(accentColor, other.accentColor, t)!,
      refColor: Color.lerp(refColor, other.refColor, t)!,
      enableCustomTheme: t < 0.5 ? enableCustomTheme : other.enableCustomTheme,
      highlightRenderMode: highlightRenderMode,
      textFontWeight: textFontWeight,
      widthAdjustmentOffset: widthAdjustmentOffset,
    );
  }
}

/// Adapter from settings -> ThemeExtension.
extension BiblePaneThemeSettingsX on BiblePaneThemeSettings {
  BiblePaneTheme toExtension() => BiblePaneTheme(
        fontFamily: fontFamily,
        fontSize: fontSize,
        textColor: textColor,
        backgroundColor: backgroundColor,
        showVerseDivider: showVerseDivider,
        showFullRefAlways: showFullRefAlways,
        accentColor: accentColor,
        refColor: refColor,
        enableCustomTheme: enableCustomTheme,
        highlightRenderMode: highlightRenderMode,
        textFontWeight: textFontWeight,
        widthAdjustmentOffset: widthAdjustmentOffset,
      );
}
