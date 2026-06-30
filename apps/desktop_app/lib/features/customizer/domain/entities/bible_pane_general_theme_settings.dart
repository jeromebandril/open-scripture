import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../shared/utils/colors_util.dart';
import 'app_font_weight.dart';

class BiblePaneGeneralThemeSettings extends Equatable {
  final String textFont;
  final double fontSize;
  final Color textColor;
  final Color backgroundColor;
  final Color accentColor;
  final Color refColor;
  final bool enableCustomTheme;
  final AppFontWeight textFontWeight;
  final double widthAdjustmentOffset;
  final String referenceFont;
  final double xPadding;
  final int splitscreenGap;
  final bool showSplitscreenDivider;
  final Color quoteColor;
  final Color addColor;
  final bool underlineStrongWords;
  final AppFontWeight selectedRefFontWeight;
  final AppFontWeight refFontWeight;

  const BiblePaneGeneralThemeSettings({
    this.textFont = 'General Sans',
    this.fontSize = 14,
    this.textColor = const Color(0xFFB9B9B9),
    this.backgroundColor = const Color(0xFF0C0C0C),
    this.accentColor = const Color(0xFFA390FF),
    this.refColor = const Color(0xFF81811E),
    this.enableCustomTheme = false,
    this.textFontWeight = AppFontWeight.semiBold,
    this.widthAdjustmentOffset = 0.0,
    this.referenceFont = 'General Sans',
    this.xPadding = 0.01,
    this.splitscreenGap = 16,
    this.showSplitscreenDivider = true,
    this.addColor = const Color(0xFFD2D2D2),
    this.quoteColor = const Color(0xFFE04A4A),
    this.selectedRefFontWeight = AppFontWeight.extraBold,
    this.refFontWeight = AppFontWeight.semiBold,
    this.underlineStrongWords = true,
  });

  factory BiblePaneGeneralThemeSettings.dark() => BiblePaneGeneralThemeSettings(
        textColor: const Color(0xFFB9B9B9),
        backgroundColor: const Color(0xFF0C0C0C),
        accentColor: const Color(0xFFA390FF),
        refColor: const Color(0xFF81811E),
        addColor: const Color(0xFFD2D2D2),
        quoteColor: const Color(0xFFE04A4A),
        textFontWeight: AppFontWeight.semiBold,
        selectedRefFontWeight: AppFontWeight.semiBold,
        refFontWeight: AppFontWeight.semiBold,
      );

  factory BiblePaneGeneralThemeSettings.light() =>
      BiblePaneGeneralThemeSettings(
        textColor: const Color(0xFF0C0C0C),
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        accentColor: const Color.fromARGB(255, 114, 34, 218),
        refColor: const Color(0xFF81811E),
        addColor: const Color(0xFF858585),
        quoteColor: const Color(0xFFE04A4A),
        textFontWeight: AppFontWeight.bold,
        selectedRefFontWeight: AppFontWeight.bold,
        refFontWeight: AppFontWeight.bold,
      );

  BiblePaneGeneralThemeSettings copyWith({
    String? textFont,
    double? fontSize,
    Color? textColor,
    Color? backgroundColor,
    Color? accentColor,
    Color? refColor,
    bool? enableCustomTheme,
    AppFontWeight? textFontWeight,
    double? widthAdjustmentOffset,
    String? referenceFont,
    double? xPadding,
    int? splitscreenGap,
    bool? showSplitscreenDivider,
    Color? quoteColor,
    Color? addColor,
    AppFontWeight? selectedRefFontWeight,
    AppFontWeight? refFontWeight,
    bool? underlineStrongWords,
  }) {
    return BiblePaneGeneralThemeSettings(
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
      showSplitscreenDivider:
          showSplitscreenDivider ?? this.showSplitscreenDivider,
      quoteColor: quoteColor ?? this.quoteColor,
      addColor: addColor ?? this.addColor,
      selectedRefFontWeight:
          selectedRefFontWeight ?? this.selectedRefFontWeight,
      refFontWeight: refFontWeight ?? this.refFontWeight,
      underlineStrongWords: underlineStrongWords ?? this.underlineStrongWords,
    );
  }

  @override
  List<Object?> get props => [
        textFont,
        fontSize,
        textColor,
        backgroundColor,
        accentColor,
        refColor,
        enableCustomTheme,
        textFontWeight,
        widthAdjustmentOffset,
        referenceFont,
        xPadding,
        splitscreenGap,
        showSplitscreenDivider,
        quoteColor,
        addColor,
        selectedRefFontWeight,
        refFontWeight,
        underlineStrongWords,
      ];

  Map<String, dynamic> toJson() => {
        'fontFamily': textFont,
        'fontSize': fontSize,
        'textColor': ColorsUtil.colorToHex(textColor),
        'backgroundColor': ColorsUtil.colorToHex(backgroundColor),
        'accentColor': ColorsUtil.colorToHex(accentColor),
        'refColor': ColorsUtil.colorToHex(refColor),
        'enableCustomTheme': enableCustomTheme,
        'textFontWeight': textFontWeight.wire,
        'widthAdjustmentOffset': widthAdjustmentOffset,
        'referenceFont': referenceFont,
        'xPadding': xPadding,
        'splitscreenGap': splitscreenGap,
        'showSplitscreenDivider': showSplitscreenDivider,
        'quoteColor': ColorsUtil.colorToHex(quoteColor),
        'addColor': ColorsUtil.colorToHex(addColor),
        'selectedRefFontWeight': selectedRefFontWeight.wire,
        'refFontWeight': refFontWeight.wire,
        'underlineStrongWords': underlineStrongWords,
      };

  static BiblePaneGeneralThemeSettings fromJson(Map<String, dynamic> json) {
    return BiblePaneGeneralThemeSettings(
      textFont: json['fontFamily'] as String,
      fontSize: (json['fontSize'] as num).toDouble(),
      textColor: Color(ColorsUtil.parseHex(json['textColor'] as String)),
      backgroundColor:
          Color(ColorsUtil.parseHex(json['backgroundColor'] as String)),
      accentColor: Color(ColorsUtil.parseHex(json['accentColor'] as String)),
      refColor: Color(ColorsUtil.parseHex(json['refColor'] as String)),
      enableCustomTheme: (json['enableCustomTheme'] as bool),
      widthAdjustmentOffset: json['widthAdjustmentOffset'] as double,
      referenceFont: json['referenceFont'] as String,
      textFontWeight:
          AppFontWeightWire.fromWire((json['textFontWeight'] as String)),
      xPadding: json['xPadding'] as double,
      splitscreenGap: json['splitscreenGap'] as int,
      showSplitscreenDivider: (json['showSplitscreenDivider'] as bool),
      quoteColor: Color(ColorsUtil.parseHex(json['quoteColor'] as String)),
      addColor: Color(ColorsUtil.parseHex(json['addColor'] as String)),
      selectedRefFontWeight:
          AppFontWeightWire.fromWire((json['selectedRefFontWeight'] as String)),
      refFontWeight:
          AppFontWeightWire.fromWire((json['refFontWeight'] as String)),
      underlineStrongWords: (json['underlineStrongWords'] as bool),
    );
  }
}
