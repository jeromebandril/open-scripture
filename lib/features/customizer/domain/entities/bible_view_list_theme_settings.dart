import 'package:equatable/equatable.dart';

import 'highlight_render_mode.dart';

class BibleViewListThemeSettings extends Equatable {
  final bool underlineRef;
  final bool showVerseDivider;
  final bool showFullRefAlways;
  final bool enableHangingRefs;
  final HighlightRenderMode highlightRenderMode;

  const BibleViewListThemeSettings({
    this.underlineRef = false,
    this.showVerseDivider = false,
    this.showFullRefAlways = false,
    this.enableHangingRefs = false,
    this.highlightRenderMode = HighlightRenderMode.fullRefWithColor,
  });

  @override
  List<Object?> get props => [
        underlineRef,
        showVerseDivider,
        showFullRefAlways,
        enableHangingRefs,
        highlightRenderMode,
      ];

  Map<String, dynamic> toJson() => {
        'underlineRef': underlineRef,
        'showVerseDivider': showVerseDivider,
        'showFullRefAlways': showFullRefAlways,
        'enableHangingRefs': enableHangingRefs,
        'highlightRenderMode': highlightRenderMode.wire,
      };

  BibleViewListThemeSettings copyWith({
    bool? underlineRef,
    bool? showVerseDivider,
    bool? showFullRefAlways,
    bool? enableHangingRefs,
    HighlightRenderMode? highlightRenderMode,
  }) {
    return BibleViewListThemeSettings(
      underlineRef: underlineRef ?? this.underlineRef,
      showVerseDivider: showVerseDivider ?? this.showVerseDivider,
      showFullRefAlways: showFullRefAlways ?? this.showFullRefAlways,
      enableHangingRefs: enableHangingRefs ?? this.enableHangingRefs,
      highlightRenderMode: highlightRenderMode ?? this.highlightRenderMode,
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
    );
  }
}
