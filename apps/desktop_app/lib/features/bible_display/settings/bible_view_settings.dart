import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../shared/utils/colors_util.dart';
import '../bible_pane/domain/display_mode.dart';
import 'domain/entities/bible_view_font_weight.dart';
import 'domain/entities/bible_view_text_align.dart';
import 'domain/entities/highlight_render_mode.dart';
import 'domain/entities/inline_verse_number_style.dart';

abstract class _Keys {
  static const enableAutoScrollToVerse = 'enableAutoScrollToVerse';
  static const verseFontFamily = 'verseFontFamily';
  static const verseColor = 'verseColor';
  static const backgroundColor = 'backgroundColor';
  static const selectedRefColor = 'selectedRefColor';
  static const refColor = 'refColor';
  static const useAppTheme = 'useAppTheme';
  static const verseFontWeight = 'verseFontWeight';
  static const widthAdjustmentOffset = 'widthAdjustmentOffset';
  static const refFontFamily = 'refFontFamily';
  static const xPadding = 'xPadding';
  static const splitscreenGap = 'splitscreenGap';
  static const quoteColor = 'quoteColor';
  static const addColor = 'addColor';
  static const enableStrongWordsRender = 'enableStrongWordsRender';
  static const selectedRefFontWeight = 'selectedRefFontWeight';
  static const refFontWeight = 'refFontWeight';
  static const underlineRefs = 'underlineRefs';
  static const showVerseDivider = 'showVerseDivider';
  static const showAlwaysFullRef = 'showAlwaysFullRef';
  static const highlightRenderMode = 'highlightRenderMode';
  static const listParallelSpacing = 'listParallelSpacing';
  static const presentationTitleTextAlign = 'presentationTitleTextAlign';
  static const presentationSubtitleTextAlign = 'presentationSubtitleTextAlign';
  static const subtitleFontWeight = 'subtitleFontWeight';
  static const inlineVerseNumberStyle = 'inlineVerseNumberStyle';
  static const presentationParallelSpacing = 'presentationParallelSpacing';
  static const emphasizeSelectedVerses = 'emphasizeSelectedVerses';
  static const unselectedOpacityLevel = 'unselectedOpacityLevel';
  static const enabledDisplayModes = 'enabledDisplayModes';
  static const defaultDisplayMode = 'defaultDisplayMode';
}

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
  final Color selectedRefColor;
  final Color verseColor;
  final Color refColor;
  // other
  final double widthAdjustmentOffset;
  final double xPadding;
  final double splitscreenGap;
  final List<DisplayMode> enabledDisplayModes;
  final DisplayMode defaultDisplayMode;
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
    this.selectedRefColor = const Color(0xFFA390FF),
    this.refColor = const Color(0xFF81811E),
    this.useAppTheme = false,
    this.verseFontWeight = BibleViewFontWeight.regular,
    this.widthAdjustmentOffset = 0.0,
    this.refFontFamily = 'General Sans',
    this.xPadding = 0.01,
    this.splitscreenGap = 64,
    this.enabledDisplayModes = const [DisplayMode.presentation],
    this.defaultDisplayMode = DisplayMode.list,
    this.quoteColor = const Color(0xFFE04A4A),
    this.addColor = const Color(0xFFD2D2D2),
    this.enableStrongWordsRender = false,
    this.selectedRefFontWeight = BibleViewFontWeight.semiBold,
    this.refFontWeight = BibleViewFontWeight.regular,
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
        selectedRefColor: Color(0xFFA390FF),
        addColor: Color(0xFFD2D2D2),
        verseFontWeight: BibleViewFontWeight.regular,
        refFontWeight: BibleViewFontWeight.regular,
        selectedRefFontWeight: BibleViewFontWeight.semiBold,
      );

  factory BibleViewSettings.defaultThemeLight() => const BibleViewSettings(
        verseColor: Color(0xFF0C0C0C),
        backgroundColor: Color.fromARGB(255, 240, 240, 240),
        selectedRefColor: Color.fromARGB(255, 114, 34, 218),
        addColor: Color(0xFF858585),
        verseFontWeight: BibleViewFontWeight.semiBold,
        refFontWeight: BibleViewFontWeight.semiBold,
        selectedRefFontWeight: BibleViewFontWeight.bold,
      );

  BibleViewSettings copyWith({
    bool? enableAutoScrollToVerse,
    String? verseFontFamily,
    Color? verseColor,
    Color? backgroundColor,
    Color? selectedRefColor,
    Color? refColor,
    bool? useAppTheme,
    BibleViewFontWeight? verseFontWeight,
    double? widthAdjustmentOffset,
    String? refFontFamily,
    double? xPadding,
    double? splitscreenGap,
    List<DisplayMode>? enabledDisplayModes,
    DisplayMode? defaultDisplayMode,
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
      selectedRefColor: selectedRefColor ?? this.selectedRefColor,
      refColor: refColor ?? this.refColor,
      useAppTheme: useAppTheme ?? this.useAppTheme,
      verseFontWeight: verseFontWeight ?? this.verseFontWeight,
      widthAdjustmentOffset:
          widthAdjustmentOffset ?? this.widthAdjustmentOffset,
      refFontFamily: refFontFamily ?? this.refFontFamily,
      xPadding: xPadding ?? this.xPadding,
      splitscreenGap: splitscreenGap ?? this.splitscreenGap,
      enabledDisplayModes: enabledDisplayModes ?? this.enabledDisplayModes,
      defaultDisplayMode: defaultDisplayMode ?? this.defaultDisplayMode,
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
        _Keys.enableAutoScrollToVerse: enableAutoScrollToVerse,
        _Keys.verseFontFamily: verseFontFamily,
        _Keys.verseColor: ColorsUtil.colorToHex(verseColor),
        _Keys.backgroundColor: ColorsUtil.colorToHex(backgroundColor),
        _Keys.selectedRefColor: ColorsUtil.colorToHex(selectedRefColor),
        _Keys.refColor: ColorsUtil.colorToHex(refColor),
        _Keys.useAppTheme: useAppTheme,
        _Keys.verseFontWeight: verseFontWeight.wire,
        _Keys.widthAdjustmentOffset: widthAdjustmentOffset,
        _Keys.refFontFamily: refFontFamily,
        _Keys.xPadding: xPadding,
        _Keys.splitscreenGap: splitscreenGap,
        _Keys.enabledDisplayModes:
            enabledDisplayModes.map((e) => e.name).toList(),
        _Keys.defaultDisplayMode: defaultDisplayMode.name,
        _Keys.quoteColor: ColorsUtil.colorToHex(quoteColor),
        _Keys.addColor: ColorsUtil.colorToHex(addColor),
        _Keys.enableStrongWordsRender: enableStrongWordsRender,
        _Keys.selectedRefFontWeight: selectedRefFontWeight.wire,
        _Keys.refFontWeight: refFontWeight.wire,
        _Keys.underlineRefs: underlineRefs,
        _Keys.showVerseDivider: showVerseDivider,
        _Keys.showAlwaysFullRef: showAlwaysFullRef,
        _Keys.highlightRenderMode: highlightRenderMode.wire,
        _Keys.listParallelSpacing: listParallelSpacing,
        _Keys.presentationTitleTextAlign: presentationTitleTextAlign.wire,
        _Keys.presentationSubtitleTextAlign: presentationSubtitleTextAlign.wire,
        _Keys.subtitleFontWeight: subtitleFontWeight.wire,
        _Keys.inlineVerseNumberStyle: inlineVerseNumberStyle.wire,
        _Keys.presentationParallelSpacing: presentationParallelSpacing,
        _Keys.emphasizeSelectedVerses: emphasizeSelectedVerses,
        _Keys.unselectedOpacityLevel: unselectedOpacityLevel,
      };

  factory BibleViewSettings.fromJson(Map<String, dynamic> json) {
    final defaults = BibleViewSettings.defaultThemeLight();

    return BibleViewSettings(
      enableAutoScrollToVerse: json[_Keys.enableAutoScrollToVerse] as bool? ??
          defaults.enableAutoScrollToVerse,
      verseFontFamily:
          json[_Keys.verseFontFamily] as String? ?? defaults.verseFontFamily,
      verseColor: json[_Keys.verseColor] != null
          ? Color(ColorsUtil.parseHex(json[_Keys.verseColor] as String))
          : defaults.verseColor,
      backgroundColor: json[_Keys.backgroundColor] != null
          ? Color(ColorsUtil.parseHex(json[_Keys.backgroundColor] as String))
          : defaults.backgroundColor,
      selectedRefColor: json[_Keys.selectedRefColor] != null
          ? Color(ColorsUtil.parseHex(json[_Keys.selectedRefColor] as String))
          : defaults.selectedRefColor,
      refColor: json[_Keys.refColor] != null
          ? Color(ColorsUtil.parseHex(json[_Keys.refColor] as String))
          : defaults.refColor,
      useAppTheme: json[_Keys.useAppTheme] as bool? ?? defaults.useAppTheme,
      verseFontWeight: json[_Keys.verseFontWeight] != null
          ? AppFontWeightWire.fromWire(json[_Keys.verseFontWeight] as String)
          : defaults.verseFontWeight,
      widthAdjustmentOffset:
          (json[_Keys.widthAdjustmentOffset] as num?)?.toDouble() ??
              defaults.widthAdjustmentOffset,
      refFontFamily:
          json[_Keys.refFontFamily] as String? ?? defaults.refFontFamily,
      xPadding: (json[_Keys.xPadding] as num?)?.toDouble() ?? defaults.xPadding,
      splitscreenGap: (json[_Keys.splitscreenGap] as num?)?.toDouble() ??
          defaults.splitscreenGap,
      enabledDisplayModes: (json[_Keys.enabledDisplayModes] as List<dynamic>?)
              ?.map((e) => DisplayMode.values.byName(e))
              .toList() ??
          defaults.enabledDisplayModes,
      defaultDisplayMode: (json[_Keys.defaultDisplayMode] as String?) != null
          ? DisplayMode.values.byName(json[_Keys.defaultDisplayMode] as String)
          : defaults.defaultDisplayMode,
      quoteColor: json[_Keys.quoteColor] != null
          ? Color(ColorsUtil.parseHex(json[_Keys.quoteColor] as String))
          : defaults.quoteColor,
      addColor: json[_Keys.addColor] != null
          ? Color(ColorsUtil.parseHex(json[_Keys.addColor] as String))
          : defaults.addColor,
      enableStrongWordsRender: json[_Keys.enableStrongWordsRender] as bool? ??
          defaults.enableStrongWordsRender,
      selectedRefFontWeight: json[_Keys.selectedRefFontWeight] != null
          ? AppFontWeightWire.fromWire(
              json[_Keys.selectedRefFontWeight] as String)
          : defaults.selectedRefFontWeight,
      refFontWeight: json[_Keys.refFontWeight] != null
          ? AppFontWeightWire.fromWire(json[_Keys.refFontWeight] as String)
          : defaults.refFontWeight,
      underlineRefs:
          json[_Keys.underlineRefs] as bool? ?? defaults.underlineRefs,
      showVerseDivider:
          json[_Keys.showVerseDivider] as bool? ?? defaults.showVerseDivider,
      showAlwaysFullRef:
          json[_Keys.showAlwaysFullRef] as bool? ?? defaults.showAlwaysFullRef,
      highlightRenderMode: json[_Keys.highlightRenderMode] != null
          ? HighlightRenderModeWire.fromWire(
              json[_Keys.highlightRenderMode] as String)
          : defaults.highlightRenderMode,
      listParallelSpacing:
          (json[_Keys.listParallelSpacing] as num?)?.toDouble() ??
              defaults.listParallelSpacing,
      presentationTitleTextAlign: json[_Keys.presentationTitleTextAlign] != null
          ? BibleViewTextAlignWire.fromWire(
              json[_Keys.presentationTitleTextAlign] as String)
          : defaults.presentationTitleTextAlign,
      presentationSubtitleTextAlign:
          json[_Keys.presentationSubtitleTextAlign] != null
              ? BibleViewTextAlignWire.fromWire(
                  json[_Keys.presentationSubtitleTextAlign] as String)
              : defaults.presentationSubtitleTextAlign,
      subtitleFontWeight: json[_Keys.subtitleFontWeight] != null
          ? AppFontWeightWire.fromWire(json[_Keys.subtitleFontWeight] as String)
          : defaults.subtitleFontWeight,
      inlineVerseNumberStyle: json[_Keys.inlineVerseNumberStyle] != null
          ? InlineVerseNumberStyleWire.fromWire(
              json[_Keys.inlineVerseNumberStyle] as String)
          : defaults.inlineVerseNumberStyle,
      presentationParallelSpacing:
          (json[_Keys.presentationParallelSpacing] as num?)?.toDouble() ??
              defaults.presentationParallelSpacing,
      emphasizeSelectedVerses: json[_Keys.emphasizeSelectedVerses] as bool? ??
          defaults.emphasizeSelectedVerses,
      unselectedOpacityLevel:
          (json[_Keys.unselectedOpacityLevel] as num?)?.toDouble() ??
              defaults.unselectedOpacityLevel,
    );
  }

  @override
  List<Object?> get props => [
        enableAutoScrollToVerse,
        verseFontFamily,
        verseColor,
        backgroundColor,
        selectedRefColor,
        refColor,
        useAppTheme,
        verseFontWeight,
        widthAdjustmentOffset,
        refFontFamily,
        xPadding,
        splitscreenGap,
        enabledDisplayModes,
        defaultDisplayMode,
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
