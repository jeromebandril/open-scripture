import 'package:flutter/material.dart';

import '../../domain/entities/bible_pane_general_theme_settings.dart';
import 'app_font_weight.dart';

@immutable
class BiblePaneGeneralTheme extends ThemeExtension<BiblePaneGeneralTheme> {
  final String? textFont;
  final double fontSize;
  final Color textColor;
  final Color backgroundColor;
  final Color accentColor;
  final Color refColor;
  final bool enableCustomTheme;
  final FontWeight textFontWeight;
  final double widthAdjustmentOffset;
  final String referenceFont;
  final double xPadding;
  final int splitscreenGap;
  final Color quoteColor;
  final Color addColor;
  final FontWeight selectedRefFontWeight;
  final FontWeight refFontWeight;

  const BiblePaneGeneralTheme({
    required this.textFont,
    required this.fontSize,
    required this.textColor,
    required this.backgroundColor,
    required this.accentColor,
    required this.refColor,
    required this.enableCustomTheme,
    required this.textFontWeight,
    required this.widthAdjustmentOffset,
    required this.referenceFont,
    required this.xPadding,
    required this.splitscreenGap,
    required this.quoteColor,
    required this.selectedRefFontWeight,
    required this.refFontWeight,
    required this.addColor,
  });

  @override
  BiblePaneGeneralTheme copyWith({
    String? textFont,
    double? fontSize,
    Color? textColor,
    Color? backgroundColor,
    Color? accentColor,
    Color? refColor,
    bool? enableCustomTheme,
    FontWeight? textFontWeight,
    double? widthAdjustmentOffset,
    String? referenceFont,
    double? xPadding,
    int? splitscreenGap,
    Color? quoteColor,
    Color? addColor,
    FontWeight? selectedRefFontWeight,
    FontWeight? refFontWeight,
  }) {
    return BiblePaneGeneralTheme(
      textFont: textFont ?? this.textFont,
      fontSize: fontSize ?? this.fontSize,
      textColor: textColor ?? this.textColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      accentColor: accentColor ?? this.accentColor,
      refColor: refColor ?? this.refColor,
      enableCustomTheme: enableCustomTheme ?? this.enableCustomTheme,
      textFontWeight: textFontWeight ?? this.textFontWeight,
      widthAdjustmentOffset:
          widthAdjustmentOffset ?? this.widthAdjustmentOffset,
      referenceFont: referenceFont ?? this.referenceFont,
      xPadding: xPadding ?? this.xPadding,
      splitscreenGap: splitscreenGap ?? this.splitscreenGap,
      quoteColor: quoteColor ?? this.quoteColor,
      selectedRefFontWeight:
          selectedRefFontWeight ?? this.selectedRefFontWeight,
      refFontWeight: refFontWeight ?? this.refFontWeight,
      addColor: addColor ?? this.addColor,
    );
  }

  @override
  BiblePaneGeneralTheme lerp(
      ThemeExtension<BiblePaneGeneralTheme>? other, double t) {
    if (other is! BiblePaneGeneralTheme) return this;
    return BiblePaneGeneralTheme(
      textFont: t < 0.5 ? textFont : other.textFont,
      fontSize: fontSize + (other.fontSize - fontSize) * t,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      accentColor: Color.lerp(accentColor, other.accentColor, t)!,
      refColor: Color.lerp(refColor, other.refColor, t)!,
      enableCustomTheme: t < 0.5 ? enableCustomTheme : other.enableCustomTheme,
      textFontWeight: textFontWeight,
      widthAdjustmentOffset: widthAdjustmentOffset,
      referenceFont: t < 0.5 ? referenceFont : other.referenceFont,
      xPadding: t < 0.5 ? xPadding : other.xPadding,
      splitscreenGap: t < 0.5 ? splitscreenGap : other.splitscreenGap,
      quoteColor: Color.lerp(quoteColor, other.quoteColor, t)!,
      addColor: Color.lerp(addColor, other.addColor, t)!,
      selectedRefFontWeight: selectedRefFontWeight,
      refFontWeight: refFontWeight,
    );
  }
}

extension BiblePaneThemeSettingsX on BiblePaneGeneralThemeSettings {
  BiblePaneGeneralTheme toExtension() => BiblePaneGeneralTheme(
        textFont: textFont,
        fontSize: fontSize,
        textColor: textColor,
        backgroundColor: backgroundColor,
        accentColor: accentColor,
        refColor: refColor,
        enableCustomTheme: enableCustomTheme,
        textFontWeight: textFontWeight.toFlutter(),
        widthAdjustmentOffset: widthAdjustmentOffset,
        referenceFont: referenceFont,
        xPadding: xPadding,
        splitscreenGap: splitscreenGap,
        quoteColor: quoteColor,
        addColor: addColor,
        selectedRefFontWeight: selectedRefFontWeight.toFlutter(),
        refFontWeight: refFontWeight.toFlutter(),
      );
}
