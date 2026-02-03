import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:the_smyrna_bible_v2/core/utils/colors_util.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_pane/presentation/widgets/parts/verse_widget.dart';
import 'package:the_smyrna_bible_v2/features/customizer/domain/entities/app_font_weight.dart';

class BiblePaneThemeSettings extends Equatable {
  final String textFont;
  final double fontSize;
  final Color textColor;
  final Color backgroundColor;
  final bool showVerseDivider;
  final bool showFullRefAlways;
  final Color accentColor;
  final Color refColor;
  final bool enableCustomTheme;
  final HighlightRenderMode highlightRenderMode;
  final AppFontWeight textFontWeight;
  final double widthAdjustmentOffset;
  final String referenceFont;
  final double xPadding;
  final int splitscreenGap;
  final bool enableHangingRefs;

  const BiblePaneThemeSettings({
    this.textFont = 'General Sans',
    this.fontSize = 14,
    this.textColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.showVerseDivider = false,
    this.showFullRefAlways = false,
    this.accentColor = const Color(0xFF5B1AB1),
    this.refColor = const Color(0xFF5C5C0C),
    this.enableCustomTheme = false,
    this.highlightRenderMode = HighlightRenderMode.fullRefWithColor,
    this.textFontWeight = AppFontWeight.regular,
    this.widthAdjustmentOffset = 0.0,
    this.referenceFont = 'General Sans',
    this.xPadding = 0.10,
    this.splitscreenGap = 16,
    this.enableHangingRefs = false,
  });

  BiblePaneThemeSettings copyWith({
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
    AppFontWeight? textFontWeight,
    double? widthAdjustmentOffset,
    String? referenceFont,
    double? xPadding,
    int? splitscreenGap,
    bool? enableHangingRefs,
  }) {
    return BiblePaneThemeSettings(
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
    );
  }

  @override
  List<Object?> get props => [
        textFont,
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
        referenceFont,
        xPadding,
        splitscreenGap,
        enableHangingRefs,
      ];

  Map<String, dynamic> toJson() => {
        'fontFamily': textFont,
        'fontSize': fontSize,
        'textColor': ColorsUtil.colorToHex(textColor),
        'backgroundColor': ColorsUtil.colorToHex(backgroundColor),
        'showVerseDivider': showVerseDivider,
        'showFullRefAlways': showFullRefAlways,
        'accentColor': ColorsUtil.colorToHex(accentColor),
        'refColor': ColorsUtil.colorToHex(refColor),
        'enableCustomTheme': enableCustomTheme,
        'highlightRenderMode': highlightRenderMode.toString(),
        'textFontWeight': textFontWeight.wire,
        'widthAdjustmentOffset': widthAdjustmentOffset,
        'referenceFont': referenceFont,
        'xPadding': xPadding,
        'splitscreenGap': splitscreenGap,
        'enableHangingRefs': enableHangingRefs,
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
      textFont: json['fontFamily'] as String,
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
      referenceFont: json['referenceFont'] as String,
      textFontWeight:
          AppFontWeightWire.fromWire((json['textFontWeight'] as String)),
      xPadding: json['xPadding'] as double,
      splitscreenGap: json['splitscreenGap'] as int,
      enableHangingRefs: json['enableHangingRefs'] as bool,
    );
  }
}

@immutable
class BiblePaneTheme extends ThemeExtension<BiblePaneTheme> {
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

  const BiblePaneTheme({
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
  });

  @override
  BiblePaneTheme copyWith({
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
  }) {
    return BiblePaneTheme(
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
    );
  }

  @override
  BiblePaneTheme lerp(ThemeExtension<BiblePaneTheme>? other, double t) {
    if (other is! BiblePaneTheme) return this;
    return BiblePaneTheme(
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
    );
  }
}

/// Adapter from settings -> ThemeExtension.
extension BiblePaneThemeSettingsX on BiblePaneThemeSettings {
  BiblePaneTheme toExtension() => BiblePaneTheme(
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
      );
}
