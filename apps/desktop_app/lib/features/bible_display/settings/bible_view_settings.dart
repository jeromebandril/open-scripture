import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../shared/utils/colors_util.dart';
import 'domain/entities/bible_view_font_weight.dart';
import 'domain/entities/bible_view_text_align.dart';
import 'domain/entities/highlight_render_mode.dart';
import 'domain/entities/inline_verse_number_style.dart';

class BibleViewSettings extends Equatable {
  // --- behavior (not view-specific)
  final bool enableAutoScrollToVerse;

  // --- GENERAL (shared appearance, applies to every view type) ---
  final String textFont;
  final double fontSize;
  final Color textColor;
  final Color backgroundColor;
  final Color accentColor;
  final Color refColor;
  final bool enableCustomTheme;
  final BibleViewFontWeight textFontWeight;
  final double widthAdjustmentOffset;
  final String referenceFont;
  final double xPadding;
  final int splitscreenGap;
  final Color quoteColor;
  final Color addColor;
  final bool underlineStrongWords;
  final BibleViewFontWeight selectedRefFontWeight;
  final BibleViewFontWeight refFontWeight;

  // --- LIST view ---
  final bool underlineRef;
  final bool showVerseDivider;
  final bool showFullRefAlways;
  final HighlightRenderMode highlightRenderMode;
  final int parallelSpacing;

  // --- PRESENTATION view ---
  final BibleViewTextAlign titleTextAlign;
  final BibleViewTextAlign textAlign;
  final BibleViewFontWeight subtitleFontWeight;
  final InlineVerseNumberStyle verseNumberStyle;
  final double parallelDistance;

  // --- PROSE view ---
  final bool emphasizeSelectedVerses;
  final double unselectedOpacityLevel;

  const BibleViewSettings({
    this.enableAutoScrollToVerse = true,
    this.textFont = 'General Sans',
    this.fontSize = 14,
    this.textColor = const Color(0xFFB9B9B9),
    this.backgroundColor = const Color(0xFF0C0C0C),
    this.accentColor = const Color(0xFFA390FF),
    this.refColor = const Color(0xFF81811E),
    this.enableCustomTheme = false,
    this.textFontWeight = BibleViewFontWeight.semiBold,
    this.widthAdjustmentOffset = 0.0,
    this.referenceFont = 'General Sans',
    this.xPadding = 0.01,
    this.splitscreenGap = 16,
    this.quoteColor = const Color(0xFFE04A4A),
    this.addColor = const Color(0xFFD2D2D2),
    this.underlineStrongWords = false,
    this.selectedRefFontWeight = BibleViewFontWeight.extraBold,
    this.refFontWeight = BibleViewFontWeight.semiBold,
    this.underlineRef = false,
    this.showVerseDivider = true,
    this.showFullRefAlways = true,
    this.highlightRenderMode = HighlightRenderMode.fullRefWithColor,
    this.parallelSpacing = 32,
    this.titleTextAlign = BibleViewTextAlign.center,
    this.textAlign = BibleViewTextAlign.center,
    this.subtitleFontWeight = BibleViewFontWeight.semiBold,
    this.verseNumberStyle = InlineVerseNumberStyle.simple,
    this.parallelDistance = 16,
    this.emphasizeSelectedVerses = true,
    this.unselectedOpacityLevel = 0.43,
  });

  factory BibleViewSettings.defaultThemeDark() => const BibleViewSettings(
        textColor: Color(0xFFB9B9B9),
        backgroundColor: Color(0xFF0C0C0C),
        accentColor: Color(0xFFA390FF),
        refColor: Color(0xFF81811E),
        addColor: Color(0xFFD2D2D2),
        quoteColor: Color(0xFFE04A4A),
        textFontWeight: BibleViewFontWeight.semiBold,
        selectedRefFontWeight: BibleViewFontWeight.semiBold,
        refFontWeight: BibleViewFontWeight.semiBold,
      );

  factory BibleViewSettings.defaultThemeLight() => const BibleViewSettings(
        textColor: Color(0xFF0C0C0C),
        backgroundColor: Color.fromARGB(255, 240, 240, 240),
        accentColor: Color.fromARGB(255, 114, 34, 218),
        refColor: Color(0xFF81811E),
        addColor: Color(0xFF858585),
        quoteColor: Color(0xFFE04A4A),
        textFontWeight: BibleViewFontWeight.bold,
        selectedRefFontWeight: BibleViewFontWeight.bold,
        refFontWeight: BibleViewFontWeight.bold,
      );

  BibleViewSettings copyWith({
    bool? enableAutoScrollToVerse,
    String? textFont,
    double? fontSize,
    Color? textColor,
    Color? backgroundColor,
    Color? accentColor,
    Color? refColor,
    bool? enableCustomTheme,
    BibleViewFontWeight? textFontWeight,
    double? widthAdjustmentOffset,
    String? referenceFont,
    double? xPadding,
    int? splitscreenGap,
    Color? quoteColor,
    Color? addColor,
    bool? underlineStrongWords,
    BibleViewFontWeight? selectedRefFontWeight,
    BibleViewFontWeight? refFontWeight,
    bool? underlineRef,
    bool? showVerseDivider,
    bool? showFullRefAlways,
    HighlightRenderMode? highlightRenderMode,
    int? parallelSpacing,
    BibleViewTextAlign? titleTextAlign,
    BibleViewTextAlign? textAlign,
    BibleViewFontWeight? subtitleFontWeight,
    InlineVerseNumberStyle? verseNumberStyle,
    double? parallelDistance,
    bool? emphasizeSelectedVerses,
    double? unselectedOpacityLevel,
  }) {
    return BibleViewSettings(
      enableAutoScrollToVerse:
          enableAutoScrollToVerse ?? this.enableAutoScrollToVerse,
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
      addColor: addColor ?? this.addColor,
      underlineStrongWords: underlineStrongWords ?? this.underlineStrongWords,
      selectedRefFontWeight:
          selectedRefFontWeight ?? this.selectedRefFontWeight,
      refFontWeight: refFontWeight ?? this.refFontWeight,
      underlineRef: underlineRef ?? this.underlineRef,
      showVerseDivider: showVerseDivider ?? this.showVerseDivider,
      showFullRefAlways: showFullRefAlways ?? this.showFullRefAlways,
      highlightRenderMode: highlightRenderMode ?? this.highlightRenderMode,
      parallelSpacing: parallelSpacing ?? this.parallelSpacing,
      titleTextAlign: titleTextAlign ?? this.titleTextAlign,
      textAlign: textAlign ?? this.textAlign,
      subtitleFontWeight: subtitleFontWeight ?? this.subtitleFontWeight,
      verseNumberStyle: verseNumberStyle ?? this.verseNumberStyle,
      parallelDistance: parallelDistance ?? this.parallelDistance,
      emphasizeSelectedVerses:
          emphasizeSelectedVerses ?? this.emphasizeSelectedVerses,
      unselectedOpacityLevel:
          unselectedOpacityLevel ?? this.unselectedOpacityLevel,
    );
  }

  Map<String, dynamic> toJson() => {
        'enableAutoScrollToVerse': enableAutoScrollToVerse,
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
        'quoteColor': ColorsUtil.colorToHex(quoteColor),
        'addColor': ColorsUtil.colorToHex(addColor),
        'underlineStrongWords': underlineStrongWords,
        'selectedRefFontWeight': selectedRefFontWeight.wire,
        'refFontWeight': refFontWeight.wire,
        'underlineRef': underlineRef,
        'showVerseDivider': showVerseDivider,
        'showFullRefAlways': showFullRefAlways,
        'highlightRenderMode': highlightRenderMode.wire,
        'parallelSpacing': parallelSpacing,
        'titleTextAlign': titleTextAlign.wire,
        'textAlign': textAlign.wire,
        'subtitleFontWeight': subtitleFontWeight.wire,
        'verseNumberStyle': verseNumberStyle.wire,
        'parallelDistance': parallelDistance,
        'emphasizeSelectedVerses': emphasizeSelectedVerses,
        'unselectedOpacityLevel': unselectedOpacityLevel,
      };

  // NOTE: reads the FLAT shape. An existing save file in the old nested
  // shape (`json['generalViewSettings']['fontFamily']`, etc.) won't match
  // any of these keys, so every field below falls through to its default
  // via `??` the first time a pre-migration file is loaded.
  factory BibleViewSettings.fromJson(Map<String, dynamic> json) {
    return BibleViewSettings(
      enableAutoScrollToVerse: json['enableAutoScrollToVerse'] as bool? ?? true,
      textFont: json['fontFamily'] as String? ?? 'General Sans',
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 14,
      textColor: json['textColor'] != null
          ? Color(ColorsUtil.parseHex(json['textColor'] as String))
          : const Color(0xFFB9B9B9),
      backgroundColor: json['backgroundColor'] != null
          ? Color(ColorsUtil.parseHex(json['backgroundColor'] as String))
          : const Color(0xFF0C0C0C),
      accentColor: json['accentColor'] != null
          ? Color(ColorsUtil.parseHex(json['accentColor'] as String))
          : const Color(0xFFA390FF),
      refColor: json['refColor'] != null
          ? Color(ColorsUtil.parseHex(json['refColor'] as String))
          : const Color(0xFF81811E),
      enableCustomTheme: json['enableCustomTheme'] as bool? ?? false,
      textFontWeight: json['textFontWeight'] != null
          ? AppFontWeightWire.fromWire(json['textFontWeight'] as String)
          : BibleViewFontWeight.semiBold,
      widthAdjustmentOffset:
          (json['widthAdjustmentOffset'] as num?)?.toDouble() ?? 0.0,
      referenceFont: json['referenceFont'] as String? ?? 'General Sans',
      xPadding: (json['xPadding'] as num?)?.toDouble() ?? 0.01,
      splitscreenGap: json['splitscreenGap'] as int? ?? 16,
      quoteColor: json['quoteColor'] != null
          ? Color(ColorsUtil.parseHex(json['quoteColor'] as String))
          : const Color(0xFFE04A4A),
      addColor: json['addColor'] != null
          ? Color(ColorsUtil.parseHex(json['addColor'] as String))
          : const Color(0xFFD2D2D2),
      underlineStrongWords: json['underlineStrongWords'] as bool? ?? false,
      selectedRefFontWeight: json['selectedRefFontWeight'] != null
          ? AppFontWeightWire.fromWire(json['selectedRefFontWeight'] as String)
          : BibleViewFontWeight.extraBold,
      refFontWeight: json['refFontWeight'] != null
          ? AppFontWeightWire.fromWire(json['refFontWeight'] as String)
          : BibleViewFontWeight.semiBold,
      underlineRef: json['underlineRef'] as bool? ?? false,
      showVerseDivider: json['showVerseDivider'] as bool? ?? true,
      showFullRefAlways: json['showFullRefAlways'] as bool? ?? true,
      highlightRenderMode: json['highlightRenderMode'] != null
          ? HighlightRenderModeWire.fromWire(
              json['highlightRenderMode'] as String)
          : HighlightRenderMode.fullRefWithColor,
      parallelSpacing: json['parallelSpacing'] as int? ?? 32,
      titleTextAlign: json['titleTextAlign'] != null
          ? BibleViewTextAlignWire.fromWire(json['titleTextAlign'] as String)
          : BibleViewTextAlign.center,
      textAlign: json['textAlign'] != null
          ? BibleViewTextAlignWire.fromWire(json['textAlign'] as String)
          : BibleViewTextAlign.center,
      subtitleFontWeight: json['subtitleFontWeight'] != null
          ? AppFontWeightWire.fromWire(json['subtitleFontWeight'] as String)
          : BibleViewFontWeight.semiBold,
      verseNumberStyle: json['verseNumberStyle'] != null
          ? InlineVerseNumberStyleWire.fromWire(
              json['verseNumberStyle'] as String)
          : InlineVerseNumberStyle.simple,
      parallelDistance: (json['parallelDistance'] as num?)?.toDouble() ?? 16,
      emphasizeSelectedVerses: json['emphasizeSelectedVerses'] as bool? ?? true,
      unselectedOpacityLevel:
          (json['unselectedOpacityLevel'] as num?)?.toDouble() ?? 0.43,
    );
  }

  @override
  List<Object?> get props => [
        enableAutoScrollToVerse,
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
        quoteColor,
        addColor,
        underlineStrongWords,
        selectedRefFontWeight,
        refFontWeight,
        underlineRef,
        showVerseDivider,
        showFullRefAlways,
        highlightRenderMode,
        parallelSpacing,
        titleTextAlign,
        textAlign,
        subtitleFontWeight,
        verseNumberStyle,
        parallelDistance,
        emphasizeSelectedVerses,
        unselectedOpacityLevel,
      ];
}
