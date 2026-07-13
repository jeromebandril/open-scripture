import 'package:flutter/material.dart';

abstract final class AppSpacing {
  AppSpacing._();

  // ---------------------------------------------------------------------------
  // Base unit
  // ---------------------------------------------------------------------------

  static const double _base = 4.0;

  // ---------------------------------------------------------------------------
  // Scale
  // ---------------------------------------------------------------------------

  /// 2 px
  static const double xs2 = _base * 0.5;

  /// 4 px
  static const double xs = _base;

  /// 8 px
  static const double sm = _base * 2;

  /// 12 px
  static const double md = _base * 3;

  /// 16 px
  static const double lg = _base * 4;

  /// 20 px
  static const double xl = _base * 5;

  /// 24 px
  static const double xl2 = _base * 6;

  /// 32 px
  static const double xl3 = _base * 8;

  /// 40 px
  static const double xl4 = _base * 10;

  /// 48 px
  static const double xl5 = _base * 12;

  /// 64 px
  static const double xl6 = _base * 16;

  /// 80 px
  static const double xl7 = _base * 20;

  /// 96 px
  static const double xl8 = _base * 24;

  // ---------------------------------------------------------------------------
  // Semantic aliases
  // ---------------------------------------------------------------------------

  /// Default padding inside cards and containers.
  static const double cardPadding = lg;

  /// Default horizontal page margin.
  static const double pagePadding = xl2;

  /// Space between form fields.
  static const double formFieldGap = md;

  /// Space between sections in a page.
  static const double sectionGap = xl4;

  // ---------------------------------------------------------------------------
  // EdgeInsets helpers
  // ---------------------------------------------------------------------------

  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);
  static const EdgeInsets paddingXl2 = EdgeInsets.all(xl2);

  static const EdgeInsets paddingHorizontalLg =
      EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets paddingHorizontalXl2 =
      EdgeInsets.symmetric(horizontal: xl2);

  static const EdgeInsets paddingVerticalSm =
      EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVerticalMd =
      EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVerticalLg =
      EdgeInsets.symmetric(vertical: lg);

  static const EdgeInsets cardEdgeInsets = EdgeInsets.all(cardPadding);

  static const EdgeInsets pageEdgeInsets =
      EdgeInsets.symmetric(horizontal: pagePadding, vertical: xl2);
}
