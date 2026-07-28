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
  final String verseFontFamily;
  final String refFontFamily;
  final BibleViewFontWeight verseFontWeight;
  final BibleViewFontWeight refFontWeight;
  final BibleViewFontWeight selectedRefFontWeight;
  final Color backgroundColor;
  final Color accentColor;
  final Color verseColor;
  final Color refColor;
  // other
  final double widthAdjustmentOffset;
  final double xPadding;
  final double splitscreenGap;
  // behavior
  final bool useAppTheme;
  final bool enableStrongWordsRender;
  // special render
  final Color quoteColor;
  final Color addColor;

  // --- LIST view ---
  final bool underlineRefs;
  final bool showVerseDivider;
  final bool showAlwaysFullRef;
  final HighlightRenderMode highlightRenderMode;
  final double listParallelSpacing;

  // --- PRESENTATION view ---
  final BibleViewTextAlign presentationTitleTextAlign;
  final BibleViewTextAlign presentationSubtitleTextAlign;
  final BibleViewFontWeight subtitleFontWeight;
  final InlineVerseNumberStyle inlineVerseNumberStyle;
  final double presentationParallelSpacing;

  // --- PROSE view ---
  final bool emphasizeSelectedVerses;
  final double unselectedOpacityLevel;

  const BibleViewSettings({
    this.enableAutoScrollToVerse = true,
    this.verseFontFamily = 'General Sans',
    this.verseColor = const Color(0xFFB9B9B9),
    this.backgroundColor = const Color(0xFF0C0C0C),
    this.accentColor = const Color(0xFFA390FF),
    this.refColor = const Color(0xFF81811E),
    this.useAppTheme = false,
    this.verseFontWeight = BibleViewFontWeight.semiBold,
    this.widthAdjustmentOffset = 0.0,
    this.refFontFamily = 'General Sans',
    this.xPadding = 0.01,
    this.splitscreenGap = 16,
    this.quoteColor = const Color(0xFFE04A4A),
    this.addColor = const Color(0xFFD2D2D2),
    this.enableStrongWordsRender = false,
    this.selectedRefFontWeight = BibleViewFontWeight.extraBold,
    this.refFontWeight = BibleViewFontWeight.semiBold,
    this.underlineRefs = false,
    this.showVerseDivider = true,
    this.showAlwaysFullRef = true,
    this.highlightRenderMode = HighlightRenderMode.fullRefWithColor,
    this.listParallelSpacing = 32,
    this.presentationTitleTextAlign = BibleViewTextAlign.center,
    this.presentationSubtitleTextAlign = BibleViewTextAlign.center,
    this.subtitleFontWeight = BibleViewFontWeight.semiBold,
    this.inlineVerseNumberStyle = InlineVerseNumberStyle.simple,
    this.presentationParallelSpacing = 16,
    this.emphasizeSelectedVerses = true,
    this.unselectedOpacityLevel = 0.43,
  });

  factory BibleViewSettings.defaultThemeDark() => const BibleViewSettings(
        verseColor: Color(0xFFB9B9B9),
        backgroundColor: Color(0xFF0C0C0C),
        accentColor: Color(0xFFA390FF),
        refColor: Color(0xFF81811E),
        addColor: Color(0xFFD2D2D2),
        quoteColor: Color(0xFFE04A4A),
        verseFontWeight: BibleViewFontWeight.semiBold,
        selectedRefFontWeight: BibleViewFontWeight.semiBold,
        refFontWeight: BibleViewFontWeight.semiBold,
      );

  factory BibleViewSettings.defaultThemeLight() => const BibleViewSettings(
        verseColor: Color(0xFF0C0C0C),
        backgroundColor: Color.fromARGB(255, 240, 240, 240),
        accentColor: Color.fromARGB(255, 114, 34, 218),
        refColor: Color(0xFF81811E),
        addColor: Color(0xFF858585),
        quoteColor: Color(0xFFE04A4A),
        verseFontWeight: BibleViewFontWeight.bold,
        selectedRefFontWeight: BibleViewFontWeight.bold,
        refFontWeight: BibleViewFontWeight.bold,
      );

  BibleViewSettings copyWith({
    bool? enableAutoScrollToVerse,
    String? verseFontFamily,
    double? fontSize,
    Color? verseColor,
    Color? backgroundColor,
    Color? accentColor,
    Color? refColor,
    bool? useAppTheme,
    BibleViewFontWeight? verseFontWeight,
    double? widthAdjustmentOffset,
    String? refFontFamily,
    double? xPadding,
    double? splitscreenGap,
    Color? quoteColor,
    Color? addColor,
    bool? enableStrongWordsRender,
    BibleViewFontWeight? selectedRefFontWeight,
    BibleViewFontWeight? refFontWeight,
    bool? underlineRefs,
    bool? showVerseDivider,
    bool? showAlwaysFullRef,
    HighlightRenderMode? highlightRenderMode,
    double? listParallelSpacing,
    BibleViewTextAlign? presentationTitleTextAlign,
    BibleViewTextAlign? presentationSubtitleTextAlign,
    BibleViewFontWeight? subtitleFontWeight,
    InlineVerseNumberStyle? inlineVerseNumberStyle,
    double? presentationParallelSpacing,
    bool? emphasizeSelectedVerses,
    double? unselectedOpacityLevel,
  }) {
    return BibleViewSettings(
      enableAutoScrollToVerse:
          enableAutoScrollToVerse ?? this.enableAutoScrollToVerse,
      verseFontFamily: verseFontFamily ?? this.verseFontFamily,
      verseColor: verseColor ?? this.verseColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      accentColor: accentColor ?? this.accentColor,
      refColor: refColor ?? this.refColor,
      useAppTheme: useAppTheme ?? this.useAppTheme,
      verseFontWeight: verseFontWeight ?? this.verseFontWeight,
      widthAdjustmentOffset:
          widthAdjustmentOffset ?? this.widthAdjustmentOffset,
      refFontFamily: refFontFamily ?? this.refFontFamily,
      xPadding: xPadding ?? this.xPadding,
      splitscreenGap: splitscreenGap ?? this.splitscreenGap,
      quoteColor: quoteColor ?? this.quoteColor,
      addColor: addColor ?? this.addColor,
      enableStrongWordsRender:
          enableStrongWordsRender ?? this.enableStrongWordsRender,
      selectedRefFontWeight:
          selectedRefFontWeight ?? this.selectedRefFontWeight,
      refFontWeight: refFontWeight ?? this.refFontWeight,
      underlineRefs: underlineRefs ?? this.underlineRefs,
      showVerseDivider: showVerseDivider ?? this.showVerseDivider,
      showAlwaysFullRef: showAlwaysFullRef ?? this.showAlwaysFullRef,
      highlightRenderMode: highlightRenderMode ?? this.highlightRenderMode,
      listParallelSpacing: listParallelSpacing ?? this.listParallelSpacing,
      presentationTitleTextAlign:
          presentationTitleTextAlign ?? this.presentationTitleTextAlign,
      presentationSubtitleTextAlign:
          presentationSubtitleTextAlign ?? this.presentationSubtitleTextAlign,
      subtitleFontWeight: subtitleFontWeight ?? this.subtitleFontWeight,
      inlineVerseNumberStyle:
          inlineVerseNumberStyle ?? this.inlineVerseNumberStyle,
      presentationParallelSpacing:
          presentationParallelSpacing ?? this.presentationParallelSpacing,
      emphasizeSelectedVerses:
          emphasizeSelectedVerses ?? this.emphasizeSelectedVerses,
      unselectedOpacityLevel:
          unselectedOpacityLevel ?? this.unselectedOpacityLevel,
    );
  }

  Map<String, dynamic> toJson() => {
        'enableAutoScrollToVerse': enableAutoScrollToVerse,
        'verseFontFamily': verseFontFamily,
        'verseColor': ColorsUtil.colorToHex(verseColor),
        'backgroundColor': ColorsUtil.colorToHex(backgroundColor),
        'accentColor': ColorsUtil.colorToHex(accentColor),
        'refColor': ColorsUtil.colorToHex(refColor),
        'useAppTheme': useAppTheme,
        'verseFontWeight': verseFontWeight.wire,
        'widthAdjustmentOffset': widthAdjustmentOffset,
        'refFontFamily': refFontFamily,
        'xPadding': xPadding,
        'splitscreenGap': splitscreenGap,
        'quoteColor': ColorsUtil.colorToHex(quoteColor),
        'addColor': ColorsUtil.colorToHex(addColor),
        'enableStrongWordsRender': enableStrongWordsRender,
        'selectedRefFontWeight': selectedRefFontWeight.wire,
        'refFontWeight': refFontWeight.wire,
        'underlineRefs': underlineRefs,
        'showVerseDivider': showVerseDivider,
        'showAlwaysFullRef': showAlwaysFullRef,
        'highlightRenderMode': highlightRenderMode.wire,
        'listParallelSpacing': listParallelSpacing,
        'presentationTitleTextAlign': presentationTitleTextAlign.wire,
        'presentationSubtitleTextAlign': presentationSubtitleTextAlign.wire,
        'subtitleFontWeight': subtitleFontWeight.wire,
        'inlineVerseNumberStyle': inlineVerseNumberStyle.wire,
        'presentationParallelSpacing': presentationParallelSpacing,
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
      verseFontFamily: json['fontFamily'] as String? ?? 'General Sans',
      verseColor: json['textColor'] != null
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
      useAppTheme: json['useAppTheme'] as bool? ?? false,
      verseFontWeight: json['textFontWeight'] != null
          ? AppFontWeightWire.fromWire(json['textFontWeight'] as String)
          : BibleViewFontWeight.semiBold,
      widthAdjustmentOffset:
          (json['widthAdjustmentOffset'] as num?)?.toDouble() ?? 0.0,
      refFontFamily: json['referenceFont'] as String? ?? 'General Sans',
      xPadding: (json['xPadding'] as num?)?.toDouble() ?? 0.01,
      splitscreenGap: json['splitscreenGap'] as double? ?? 16,
      quoteColor: json['quoteColor'] != null
          ? Color(ColorsUtil.parseHex(json['quoteColor'] as String))
          : const Color(0xFFE04A4A),
      addColor: json['addColor'] != null
          ? Color(ColorsUtil.parseHex(json['addColor'] as String))
          : const Color(0xFFD2D2D2),
      enableStrongWordsRender: json['underlineStrongWords'] as bool? ?? false,
      selectedRefFontWeight: json['selectedRefFontWeight'] != null
          ? AppFontWeightWire.fromWire(json['selectedRefFontWeight'] as String)
          : BibleViewFontWeight.extraBold,
      refFontWeight: json['refFontWeight'] != null
          ? AppFontWeightWire.fromWire(json['refFontWeight'] as String)
          : BibleViewFontWeight.semiBold,
      underlineRefs: json['underlineRef'] as bool? ?? false,
      showVerseDivider: json['showVerseDivider'] as bool? ?? true,
      showAlwaysFullRef: json['showFullRefAlways'] as bool? ?? true,
      highlightRenderMode: json['highlightRenderMode'] != null
          ? HighlightRenderModeWire.fromWire(
              json['highlightRenderMode'] as String)
          : HighlightRenderMode.fullRefWithColor,
      listParallelSpacing: json['parallelSpacing'] as double? ?? 32,
      presentationTitleTextAlign: json['titleTextAlign'] != null
          ? BibleViewTextAlignWire.fromWire(json['titleTextAlign'] as String)
          : BibleViewTextAlign.center,
      presentationSubtitleTextAlign: json['textAlign'] != null
          ? BibleViewTextAlignWire.fromWire(json['textAlign'] as String)
          : BibleViewTextAlign.center,
      subtitleFontWeight: json['subtitleFontWeight'] != null
          ? AppFontWeightWire.fromWire(json['subtitleFontWeight'] as String)
          : BibleViewFontWeight.semiBold,
      inlineVerseNumberStyle: json['verseNumberStyle'] != null
          ? InlineVerseNumberStyleWire.fromWire(
              json['verseNumberStyle'] as String)
          : InlineVerseNumberStyle.simple,
      presentationParallelSpacing:
          (json['parallelDistance'] as num?)?.toDouble() ?? 16,
      emphasizeSelectedVerses: json['emphasizeSelectedVerses'] as bool? ?? true,
      unselectedOpacityLevel:
          (json['unselectedOpacityLevel'] as num?)?.toDouble() ?? 0.43,
    );
  }

  @override
  List<Object?> get props => [
        enableAutoScrollToVerse,
        verseFontFamily,
        verseColor,
        backgroundColor,
        accentColor,
        refColor,
        useAppTheme,
        verseFontWeight,
        widthAdjustmentOffset,
        refFontFamily,
        xPadding,
        splitscreenGap,
        quoteColor,
        addColor,
        enableStrongWordsRender,
        selectedRefFontWeight,
        refFontWeight,
        underlineRefs,
        showVerseDivider,
        showAlwaysFullRef,
        highlightRenderMode,
        listParallelSpacing,
        presentationTitleTextAlign,
        presentationSubtitleTextAlign,
        subtitleFontWeight,
        inlineVerseNumberStyle,
        presentationParallelSpacing,
        emphasizeSelectedVerses,
        unselectedOpacityLevel,
      ];
}
