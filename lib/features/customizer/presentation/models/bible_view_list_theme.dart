import 'package:flutter/material.dart';

import '../../domain/entities/bible_view_list_theme_settings.dart';
import '../../domain/entities/highlight_render_mode.dart';

@immutable
class BibleViewListTheme extends ThemeExtension<BibleViewListTheme> {
  final TextDecoration underlineRef;
  final bool showVerseDivider;
  final bool enableHangingRefs;
  final bool showFullRefAlways;
  final HighlightRenderMode highlightRenderMode;

  const BibleViewListTheme({
    required this.underlineRef,
    required this.showVerseDivider,
    required this.enableHangingRefs,
    required this.showFullRefAlways,
    required this.highlightRenderMode,
  });

  @override
  ThemeExtension<BibleViewListTheme> copyWith({
    TextDecoration? underlineRef,
    bool? showVerseDivider,
    bool? showFullRefAlways,
    bool? enableHangingRefs,
    HighlightRenderMode? highlightRenderMode,
  }) {
    return BibleViewListTheme(
      underlineRef: underlineRef ?? this.underlineRef,
      showVerseDivider: showVerseDivider ?? this.showVerseDivider,
      showFullRefAlways: showFullRefAlways ?? this.showFullRefAlways,
      enableHangingRefs: enableHangingRefs ?? this.enableHangingRefs,
      highlightRenderMode: highlightRenderMode ?? this.highlightRenderMode,
    );
  }

  @override
  ThemeExtension<BibleViewListTheme> lerp(
      covariant ThemeExtension<BibleViewListTheme>? other, double t) {
    if (other is! BibleViewListTheme) return this;
    return BibleViewListTheme(
      underlineRef: underlineRef,
      showVerseDivider: t < 0.5 ? showVerseDivider : other.showVerseDivider,
      showFullRefAlways: t < 0.5 ? showFullRefAlways : other.showFullRefAlways,
      enableHangingRefs: t < 0.5 ? enableHangingRefs : other.enableHangingRefs,
      highlightRenderMode: highlightRenderMode,
    );
  }
}

extension BibleViewListThemeX on BibleViewListThemeSettings {
  BibleViewListTheme toExtension() => BibleViewListTheme(
        underlineRef:
            underlineRef ? TextDecoration.underline : TextDecoration.none,
        showVerseDivider: showVerseDivider,
        showFullRefAlways: showFullRefAlways,
        enableHangingRefs: enableHangingRefs,
        highlightRenderMode: highlightRenderMode,
      );
}
