import 'package:flutter/material.dart';

abstract final class AppRadius {
  AppRadius._();

  /// 2 px -- subtle, almost sharp.
  static const double xs = 2.0;

  /// 4 px -- inputs, small chips.
  static const double sm = 4.0;

  /// 8 px -- default for most components.
  static const double md = 8.0;

  /// 12 px -- cards, dialogs.
  static const double lg = 12.0;

  /// 16 px -- elevated panels, sheets.
  static const double xl = 16.0;

  /// 24 px -- large modals, drawers.
  static const double xl2 = 24.0;

  /// Pill / fully rounded (use with `BorderRadius.circular`).
  static const double full = 999.0;

  // ---------------------------------------------------------------------------
  // BorderRadius helpers
  // ---------------------------------------------------------------------------

  static const BorderRadius radiusXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius radiusXl2 = BorderRadius.all(Radius.circular(xl2));
  static const BorderRadius radiusFull =
      BorderRadius.all(Radius.circular(full));

  // ---------------------------------------------------------------------------
  // Semantic aliases
  // ---------------------------------------------------------------------------

  /// Default radius for button components.
  static const BorderRadius button = radiusMd;

  /// Default radius for text input fields.
  static const BorderRadius input = radiusMd;

  /// Default radius for card components.
  static const BorderRadius card = radiusLg;

  /// Default radius for dialog components.
  static const BorderRadius dialog = radiusXl;

  /// Default radius for bottom sheet / side panel.
  static const BorderRadius sheet = BorderRadius.only(
    topLeft: Radius.circular(xl2),
    topRight: Radius.circular(xl2),
  );

  /// Default radius for tooltip components.
  static const BorderRadius tooltip = radiusSm;

  /// Default radius for chip components.
  static const BorderRadius chip = radiusFull;
}
