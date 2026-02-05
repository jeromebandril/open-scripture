import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:open_scripture/core/utils/colors_util.dart';
import 'package:open_scripture/features/customizer/domain/entities/app_font_weight.dart';

import 'highlight_render_mode.dart';

class BiblePaneGeneralThemeSettings extends Equatable {
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
  final Color quoteColor;
  final AppFontWeight selectedRefFontWeight;
  final AppFontWeight refFontWeight;

  const BiblePaneGeneralThemeSettings({
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
    this.quoteColor = const Color(0xFFB71C1C),
    this.selectedRefFontWeight = AppFontWeight.extraBold,
    this.refFontWeight = AppFontWeight.medium,
  });

  BiblePaneGeneralThemeSettings copyWith(
      {String? textFont,
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
      Color? quoteColor,
      AppFontWeight? selectedRefFontWeight,
      AppFontWeight? refFontWeight}) {
    return BiblePaneGeneralThemeSettings(
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
        quoteColor,
        selectedRefFontWeight,
        refFontWeight,
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
        'highlightRenderMode': highlightRenderMode.wire,
        'textFontWeight': textFontWeight.wire,
        'widthAdjustmentOffset': widthAdjustmentOffset,
        'referenceFont': referenceFont,
        'xPadding': xPadding,
        'splitscreenGap': splitscreenGap,
        'enableHangingRefs': enableHangingRefs,
        'quoteColor': ColorsUtil.colorToHex(quoteColor),
        'selectedRefFontWeight': selectedRefFontWeight.wire,
        'refFontWeight': refFontWeight.wire,
      };

  static BiblePaneGeneralThemeSettings fromJson(Map<String, dynamic> json) {
    return BiblePaneGeneralThemeSettings(
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
      highlightRenderMode: HighlightRenderModeWire.fromWire(
          json['highlightRenderMode'] as String),
      widthAdjustmentOffset: json['widthAdjustmentOffset'] as double,
      referenceFont: json['referenceFont'] as String,
      textFontWeight:
          AppFontWeightWire.fromWire((json['textFontWeight'] as String)),
      xPadding: json['xPadding'] as double,
      splitscreenGap: json['splitscreenGap'] as int,
      enableHangingRefs: json['enableHangingRefs'] as bool,
      quoteColor: Color(ColorsUtil.parseHex(json['quoteColor'] as String)),
      selectedRefFontWeight:
          AppFontWeightWire.fromWire((json['selectedRefFontWeight'] as String)),
      refFontWeight:
          AppFontWeightWire.fromWire((json['refFontWeight'] as String)),
    );
  }
}
