import 'package:equatable/equatable.dart';

import 'highlight_render_mode.dart';

class BibleViewListThemeSettings extends Equatable {
  final bool underlineRef;
  final bool showVerseDivider;
  final bool showFullRefAlways;
  final bool enableHangingRefs;
  final int parallelSpacing;
  final HighlightRenderMode highlightRenderMode;

  const BibleViewListThemeSettings({
    this.underlineRef = true,
    this.showVerseDivider = false,
    this.showFullRefAlways = true,
    this.enableHangingRefs = false,
    this.highlightRenderMode = HighlightRenderMode.fullRefWithColor,
    this.parallelSpacing = 32,
  });

  @override
  List<Object?> get props => [
        underlineRef,
        showVerseDivider,
        showFullRefAlways,
        enableHangingRefs,
        highlightRenderMode,
        parallelSpacing,
      ];

  Map<String, dynamic> toJson() => {
        'underlineRef': underlineRef,
        'showVerseDivider': showVerseDivider,
        'showFullRefAlways': showFullRefAlways,
        'enableHangingRefs': enableHangingRefs,
        'highlightRenderMode': highlightRenderMode.wire,
        'parallelSpacing': parallelSpacing,
      };

  BibleViewListThemeSettings copyWith({
    bool? underlineRef,
    bool? showVerseDivider,
    bool? showFullRefAlways,
    bool? enableHangingRefs,
    HighlightRenderMode? highlightRenderMode,
    int? parallelSpacing,
  }) {
    return BibleViewListThemeSettings(
      underlineRef: underlineRef ?? this.underlineRef,
      showVerseDivider: showVerseDivider ?? this.showVerseDivider,
      showFullRefAlways: showFullRefAlways ?? this.showFullRefAlways,
      enableHangingRefs: enableHangingRefs ?? this.enableHangingRefs,
      highlightRenderMode: highlightRenderMode ?? this.highlightRenderMode,
      parallelSpacing: parallelSpacing ?? this.parallelSpacing,
    );
  }

  static BibleViewListThemeSettings fromJson(Map<String, dynamic> json) {
    return BibleViewListThemeSettings(
        underlineRef: json['underlineRef'] as bool,
        showVerseDivider: (json['showVerseDivider'] as bool),
        showFullRefAlways: (json['showFullRefAlways'] as bool),
        enableHangingRefs: json['enableHangingRefs'] as bool,
        highlightRenderMode: HighlightRenderModeWire.fromWire(
            json['highlightRenderMode'] as String),
        parallelSpacing: json['parallelSpacing'] as int);
  }
}
