import 'package:flutter/material.dart';

import '../../domain/entities/bible_pane_general_theme_settings.dart';
import '../../domain/entities/highlight_render_mode.dart';
import 'app_font_weight.dart';

@immutable
class BiblePaneGeneralTheme extends ThemeExtension<BiblePaneGeneralTheme> {
  final String? textFont;
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
  final String referenceFont;
  final double xPadding;
  final int splitscreenGap;
  final bool enableHangingRefs;
  final Color quoteColor;
  final FontWeight selectedRefFontWeight;
  final FontWeight refFontWeight;

  const BiblePaneGeneralTheme({
    required this.textFont,
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
    required this.referenceFont,
    required this.xPadding,
    required this.splitscreenGap,
    required this.enableHangingRefs,
    required this.quoteColor,
    required this.selectedRefFontWeight,
    required this.refFontWeight,
  });

  @override
  BiblePaneGeneralTheme copyWith({
    String? textFont,
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
    String? referenceFont,
    double? xPadding,
    int? splitscreenGap,
    bool? enableHangingRefs,
    Color? quoteColor,
    FontWeight? selectedRefFontWeight,
    FontWeight? refFontWeight,
  }) {
    return BiblePaneGeneralTheme(
      textFont: textFont ?? this.textFont,
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
      referenceFont: referenceFont ?? this.referenceFont,
      xPadding: xPadding ?? this.xPadding,
      splitscreenGap: splitscreenGap ?? this.splitscreenGap,
      enableHangingRefs: enableHangingRefs ?? this.enableHangingRefs,
      quoteColor: quoteColor ?? this.quoteColor,
      selectedRefFontWeight:
          selectedRefFontWeight ?? this.selectedRefFontWeight,
      refFontWeight: refFontWeight ?? this.refFontWeight,
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
      showVerseDivider: t < 0.5 ? showVerseDivider : other.showVerseDivider,
      showFullRefAlways: t < 0.5 ? showFullRefAlways : other.showFullRefAlways,
      accentColor: Color.lerp(accentColor, other.accentColor, t)!,
      refColor: Color.lerp(refColor, other.refColor, t)!,
      enableCustomTheme: t < 0.5 ? enableCustomTheme : other.enableCustomTheme,
      highlightRenderMode: highlightRenderMode,
      textFontWeight: textFontWeight,
      widthAdjustmentOffset: widthAdjustmentOffset,
      referenceFont: t < 0.5 ? referenceFont : other.referenceFont,
      xPadding: t < 0.5 ? xPadding : other.xPadding,
      splitscreenGap: t < 0.5 ? splitscreenGap : other.splitscreenGap,
      enableHangingRefs: t < 0.5 ? enableHangingRefs : other.enableHangingRefs,
      quoteColor: Color.lerp(quoteColor, other.quoteColor, t)!,
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
        showVerseDivider: showVerseDivider,
        showFullRefAlways: showFullRefAlways,
        accentColor: accentColor,
        refColor: refColor,
        enableCustomTheme: enableCustomTheme,
        highlightRenderMode: highlightRenderMode,
        textFontWeight: textFontWeight.toFlutter(),
        widthAdjustmentOffset: widthAdjustmentOffset,
        referenceFont: referenceFont,
        xPadding: xPadding,
        splitscreenGap: splitscreenGap,
        enableHangingRefs: enableHangingRefs,
        quoteColor: quoteColor,
        selectedRefFontWeight: selectedRefFontWeight.toFlutter(),
        refFontWeight: refFontWeight.toFlutter(),
      );
}
