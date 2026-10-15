import 'package:equatable/equatable.dart';
import '../../../shared/domain/entities/display_options.dart';
import '../bible_pane/domain/display_mode.dart';
import '../colorschemes/domain/entities/bible_view_colorscheme.dart';
import 'domain/entities/bible_view_options.dart';

abstract class _Keys {
  static const enableAutoScrollToVerse = 'enableAutoScrollToVerse';
  static const verseFontFamily = 'verseFontFamily';
  static const verseFontWeight = 'verseFontWeight';
  static const widthAdjustmentOffset = 'widthAdjustmentOffset';
  static const refFontFamily = 'refFontFamily';
  static const xPadding = 'xPadding';
  static const splitscreenGap = 'splitscreenGap';
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
  static const verseSpacing = 'verseSpacing';
  static const verseLetterSpacing = 'verseLetterSpacing';
  static const enablePericope = 'enablePericope';
  static const pericopeSpacingBefore = 'pericopeSpacingBefore';
  static const pericopeSpacingAfter = 'pericopeSpacingAfter';
  static const pericopeUnderline = 'pericopeUnderline';
  static const colorscheme = 'colorscheme';
}

class BibleViewSettings extends Equatable {
  // --- behavior (not view-specific)
  final bool enableAutoScrollToVerse;

  // --- COLORS (all colors live in a BibleViewColorscheme, selected by name) ---
  /// Name of the colorscheme to use. Resolve it with
  /// [BibleViewColorscheme.resolve]; if nothing matches, the default is used.
  final String colorschemeName;

  // --- GENERAL (shared appearance, applies to every view type) ---
  final String verseFontFamily;
  final String refFontFamily;
  final AppFontWeight verseFontWeight;
  final AppFontWeight refFontWeight;
  final AppFontWeight selectedRefFontWeight;
  final double? verseLetterSpacing;
  // other
  final double widthAdjustmentOffset;
  final double xPadding;
  final double splitscreenGap;
  final List<DisplayMode> enabledDisplayModes;
  final DisplayMode defaultDisplayMode;
  // behavior
  final bool enableStrongWordsRender;
  // pericope
  final bool enablePericope;
  final double pericopeSpacingBefore;
  final double pericopeSpacingAfter;
  final bool pericopeUnderline;

  // --- LIST view ---
  final bool underlineRefs;
  final bool showVerseDivider;
  final bool showAlwaysFullRef;
  final HighlightRenderMode highlightRenderMode;
  final double listParallelSpacing;
  final double verseSpacing;

  // --- PRESENTATION view ---
  final AppTextAlign presentationTitleTextAlign;
  final AppTextAlign presentationSubtitleTextAlign;
  final AppFontWeight subtitleFontWeight;
  final InlineVerseNumberStyle inlineVerseNumberStyle;
  final double presentationParallelSpacing;

  // --- PROSE view ---
  final bool emphasizeSelectedVerses;
  final double unselectedOpacityLevel;

  const BibleViewSettings({
    this.enableAutoScrollToVerse = true,
    this.colorschemeName = BibleViewColorscheme.defaultLightName,
    this.verseFontFamily = 'General Sans',
    // ignore: avoid_init_to_null
    this.verseLetterSpacing = null,
    this.verseFontWeight = AppFontWeight.regular,
    this.widthAdjustmentOffset = 0.0,
    this.refFontFamily = 'General Sans',
    this.xPadding = 0.01,
    this.splitscreenGap = 64,
    this.enabledDisplayModes = const [
      DisplayMode.list,
      DisplayMode.presentation
    ],
    this.defaultDisplayMode = DisplayMode.list,
    this.enablePericope = true,
    this.pericopeSpacingBefore = 10,
    this.pericopeSpacingAfter = 10,
    this.pericopeUnderline = true,
    this.enableStrongWordsRender = false,
    this.selectedRefFontWeight = AppFontWeight.semiBold,
    this.refFontWeight = AppFontWeight.medium,
    this.underlineRefs = false,
    this.showVerseDivider = true,
    this.showAlwaysFullRef = true,
    this.highlightRenderMode = HighlightRenderMode.shortRefWithColor,
    this.listParallelSpacing = 32,
    this.verseSpacing = 32,
    this.presentationTitleTextAlign = AppTextAlign.center,
    this.presentationSubtitleTextAlign = AppTextAlign.center,
    this.subtitleFontWeight = AppFontWeight.medium,
    this.inlineVerseNumberStyle = InlineVerseNumberStyle.simple,
    this.presentationParallelSpacing = 16,
    this.emphasizeSelectedVerses = true,
    this.unselectedOpacityLevel = 0.43,
  });

  factory BibleViewSettings.defaultThemeDark() => const BibleViewSettings(
        verseFontWeight: AppFontWeight.medium,
        refFontWeight: AppFontWeight.medium,
        selectedRefFontWeight: AppFontWeight.semiBold,
        colorschemeName: BibleViewColorscheme.defaultDarkName,
      );

  factory BibleViewSettings.defaultThemeLight() => const BibleViewSettings(
        verseFontWeight: AppFontWeight.medium,
        refFontWeight: AppFontWeight.medium,
        selectedRefFontWeight: AppFontWeight.semiBold,
        colorschemeName: BibleViewColorscheme.defaultLightName,
      );

  BibleViewSettings copyWith({
    bool? enableAutoScrollToVerse,
    String? colorschemeName,
    String? verseFontFamily,
    double? Function()? textHeight,
    double? Function()? verseLetterSpacing,
    AppFontWeight? verseFontWeight,
    double? widthAdjustmentOffset,
    String? refFontFamily,
    double? xPadding,
    double? splitscreenGap,
    List<DisplayMode>? enabledDisplayModes,
    DisplayMode? defaultDisplayMode,
    bool? highlightStrongsWordsOnHover,
    bool? enablePericope,
    double? pericopeSpacingBefore,
    double? pericopeSpacingAfter,
    bool? pericopeUnderline,
    bool? enableStrongWordsRender,
    AppFontWeight? selectedRefFontWeight,
    AppFontWeight? refFontWeight,
    bool? underlineRefs,
    bool? showVerseDivider,
    bool? showAlwaysFullRef,
    HighlightRenderMode? highlightRenderMode,
    double? listParallelSpacing,
    double? verseSpacing,
    AppTextAlign? presentationTitleTextAlign,
    AppTextAlign? presentationSubtitleTextAlign,
    AppFontWeight? subtitleFontWeight,
    InlineVerseNumberStyle? inlineVerseNumberStyle,
    double? presentationParallelSpacing,
    bool? emphasizeSelectedVerses,
    double? unselectedOpacityLevel,
  }) {
    return BibleViewSettings(
      enableAutoScrollToVerse:
          enableAutoScrollToVerse ?? this.enableAutoScrollToVerse,
      colorschemeName: colorschemeName ?? this.colorschemeName,
      verseFontFamily: verseFontFamily ?? this.verseFontFamily,
      verseLetterSpacing: verseLetterSpacing != null
          ? verseLetterSpacing()
          : this.verseLetterSpacing,
      verseFontWeight: verseFontWeight ?? this.verseFontWeight,
      widthAdjustmentOffset:
          widthAdjustmentOffset ?? this.widthAdjustmentOffset,
      refFontFamily: refFontFamily ?? this.refFontFamily,
      xPadding: xPadding ?? this.xPadding,
      splitscreenGap: splitscreenGap ?? this.splitscreenGap,
      enabledDisplayModes: enabledDisplayModes ?? this.enabledDisplayModes,
      defaultDisplayMode: defaultDisplayMode ?? this.defaultDisplayMode,
      enablePericope: enablePericope ?? this.enablePericope,
      pericopeSpacingBefore:
          pericopeSpacingBefore ?? this.pericopeSpacingBefore,
      pericopeSpacingAfter: pericopeSpacingAfter ?? this.pericopeSpacingAfter,
      pericopeUnderline: pericopeUnderline ?? this.pericopeUnderline,
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
      verseSpacing: verseSpacing ?? this.verseSpacing,
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
        _Keys.colorscheme: colorschemeName,
        _Keys.verseFontFamily: verseFontFamily,
        _Keys.verseLetterSpacing: verseLetterSpacing,
        _Keys.verseFontWeight: verseFontWeight.name,
        _Keys.widthAdjustmentOffset: widthAdjustmentOffset,
        _Keys.refFontFamily: refFontFamily,
        _Keys.xPadding: xPadding,
        _Keys.splitscreenGap: splitscreenGap,
        _Keys.enabledDisplayModes:
            enabledDisplayModes.map((e) => e.name).toList(),
        _Keys.defaultDisplayMode: defaultDisplayMode.name,
        _Keys.enablePericope: enablePericope,
        _Keys.pericopeSpacingBefore: pericopeSpacingBefore,
        _Keys.pericopeSpacingAfter: pericopeSpacingAfter,
        _Keys.pericopeUnderline: pericopeUnderline,
        _Keys.enableStrongWordsRender: enableStrongWordsRender,
        _Keys.selectedRefFontWeight: selectedRefFontWeight.name,
        _Keys.refFontWeight: refFontWeight.name,
        _Keys.underlineRefs: underlineRefs,
        _Keys.showVerseDivider: showVerseDivider,
        _Keys.showAlwaysFullRef: showAlwaysFullRef,
        _Keys.highlightRenderMode: highlightRenderMode.name,
        _Keys.listParallelSpacing: listParallelSpacing,
        _Keys.verseSpacing: verseSpacing,
        _Keys.presentationTitleTextAlign: presentationTitleTextAlign.name,
        _Keys.presentationSubtitleTextAlign: presentationSubtitleTextAlign.name,
        _Keys.subtitleFontWeight: subtitleFontWeight.name,
        _Keys.inlineVerseNumberStyle: inlineVerseNumberStyle.name,
        _Keys.presentationParallelSpacing: presentationParallelSpacing,
        _Keys.emphasizeSelectedVerses: emphasizeSelectedVerses,
        _Keys.unselectedOpacityLevel: unselectedOpacityLevel,
      };

  factory BibleViewSettings.fromJson(Map<String, dynamic> json) {
    final defaults = BibleViewSettings.defaultThemeLight();

    return BibleViewSettings(
      enableAutoScrollToVerse: json[_Keys.enableAutoScrollToVerse] as bool? ??
          defaults.enableAutoScrollToVerse,
      colorschemeName:
          json[_Keys.colorscheme] as String? ?? defaults.colorschemeName,
      verseFontFamily:
          json[_Keys.verseFontFamily] as String? ?? defaults.verseFontFamily,
      verseLetterSpacing: json[_Keys.verseLetterSpacing] != null
          ? json[_Keys.verseLetterSpacing] as double
          : defaults.verseLetterSpacing,
      verseFontWeight: json[_Keys.verseFontWeight] != null
          ? AppFontWeight.values.byName(json[_Keys.verseFontWeight] as String)
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
      enablePericope:
          json[_Keys.enablePericope] as bool? ?? defaults.enablePericope,
      pericopeSpacingBefore:
          (json[_Keys.pericopeSpacingBefore] as num?)?.toDouble() ??
              defaults.pericopeSpacingBefore,
      pericopeSpacingAfter:
          (json[_Keys.pericopeSpacingAfter] as num?)?.toDouble() ??
              defaults.pericopeSpacingAfter,
      pericopeUnderline:
          json[_Keys.pericopeUnderline] as bool? ?? defaults.pericopeUnderline,
      enableStrongWordsRender: json[_Keys.enableStrongWordsRender] as bool? ??
          defaults.enableStrongWordsRender,
      selectedRefFontWeight: json[_Keys.selectedRefFontWeight] != null
          ? AppFontWeight.values
              .byName(json[_Keys.selectedRefFontWeight] as String)
          : defaults.selectedRefFontWeight,
      refFontWeight: json[_Keys.refFontWeight] != null
          ? AppFontWeight.values.byName(json[_Keys.refFontWeight] as String)
          : defaults.refFontWeight,
      underlineRefs:
          json[_Keys.underlineRefs] as bool? ?? defaults.underlineRefs,
      showVerseDivider:
          json[_Keys.showVerseDivider] as bool? ?? defaults.showVerseDivider,
      showAlwaysFullRef:
          json[_Keys.showAlwaysFullRef] as bool? ?? defaults.showAlwaysFullRef,
      highlightRenderMode: json[_Keys.highlightRenderMode] != null
          ? HighlightRenderMode.values
              .byName(json[_Keys.highlightRenderMode] as String)
          : defaults.highlightRenderMode,
      listParallelSpacing:
          (json[_Keys.listParallelSpacing] as num?)?.toDouble() ??
              defaults.listParallelSpacing,
      verseSpacing: (json[_Keys.verseSpacing] as num?)?.toDouble() ??
          defaults.verseSpacing,
      presentationTitleTextAlign: json[_Keys.presentationTitleTextAlign] != null
          ? AppTextAlign.values
              .byName(json[_Keys.presentationTitleTextAlign] as String)
          : defaults.presentationTitleTextAlign,
      presentationSubtitleTextAlign:
          json[_Keys.presentationSubtitleTextAlign] != null
              ? AppTextAlign.values
                  .byName(json[_Keys.presentationSubtitleTextAlign] as String)
              : defaults.presentationSubtitleTextAlign,
      subtitleFontWeight: json[_Keys.subtitleFontWeight] != null
          ? AppFontWeight.values
              .byName(json[_Keys.subtitleFontWeight] as String)
          : defaults.subtitleFontWeight,
      inlineVerseNumberStyle: json[_Keys.inlineVerseNumberStyle] != null
          ? InlineVerseNumberStyle.values
              .byName(json[_Keys.inlineVerseNumberStyle] as String)
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
        colorschemeName,
        verseFontFamily,
        verseLetterSpacing,
        verseFontWeight,
        widthAdjustmentOffset,
        refFontFamily,
        xPadding,
        splitscreenGap,
        enabledDisplayModes,
        defaultDisplayMode,
        enablePericope,
        pericopeSpacingBefore,
        pericopeSpacingAfter,
        pericopeUnderline,
        enableStrongWordsRender,
        selectedRefFontWeight,
        refFontWeight,
        underlineRefs,
        showVerseDivider,
        showAlwaysFullRef,
        highlightRenderMode,
        listParallelSpacing,
        verseSpacing,
        presentationTitleTextAlign,
        presentationSubtitleTextAlign,
        subtitleFontWeight,
        inlineVerseNumberStyle,
        presentationParallelSpacing,
        emphasizeSelectedVerses,
        unselectedOpacityLevel,
      ];
}
