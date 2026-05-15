import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../customizer/presentation/models/bible_view_list_theme.dart';

class VerseDivider extends StatelessWidget {
  const VerseDivider({super.key});

  // scaling formula definitely not done by me ahah
  //
  // How to tune:
  // Want less spacing at small fonts → increase pSmall (try 1.15 → 1.5)
  // Want spacing to also grow slower when very large → set pLarge to 0.85–0.95
  // Choose f0 and s0 based on the size where it “looks correct”
  double _spacingFromFont(
    double f, {
    double f0 =
        48.0, // font size where spacing looks correct (your "max zoom" reference)
    double s0 = 36.0, // spacing you want at f0
    double pSmall = 1.25, // >1 => extra shrink when f < f0
    double pLarge =
        1.2, // 1.0 => proportional above f0 (or try 0.9 for slower growth)
    double min = 8.0,
    double max = 144.0,
  }) {
    final r = (f / f0).clamp(0.01, 1000.0);
    final p = (f < f0) ? pSmall : pLarge;
    final raw = s0 * math.pow(r, p).toDouble();
    return raw.clamp(min, max);
  }

  @override
  Widget build(BuildContext context) {
    final base = DefaultTextStyle.of(context).style.fontSize ?? 14;
    final effectiveFontSize = MediaQuery.of(context).textScaler.scale(base);
    final spacerHeight = _spacingFromFont(effectiveFontSize);

    final isEnabled =
        Theme.of(context).extension<BibleViewListTheme>()!.showVerseDivider;

    return isEnabled
        ? Container(
            margin: EdgeInsets.symmetric(vertical: spacerHeight / 1.2),
            child: Divider(height: 1),
          )
        : SizedBox(height: spacerHeight);
  }
}
