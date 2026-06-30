import 'package:flutter/material.dart';

import 'colors.dart';

/// Elevation / shadow tokens.
///
/// Mirrors Material 3's tonal elevation philosophy but expressed as
/// explicit box shadows so they work identically on every platform.
abstract final class AppShadows {
  AppShadows._();

  // ---------------------------------------------------------------------------
  // Shadow scale
  // ---------------------------------------------------------------------------

  /// No elevation — flat, inlined elements.
  static const List<BoxShadow> none = [];

  /// 1 dp — subtle depth for hovered states.
  static final List<BoxShadow> xs = [
    BoxShadow(
      color: AppColors.withOpacity(Colors.black, 0.04),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];

  /// 2 dp — default resting cards.
  static final List<BoxShadow> sm = [
    BoxShadow(
      color: AppColors.withOpacity(Colors.black, 0.06),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
    BoxShadow(
      color: AppColors.withOpacity(Colors.black, 0.04),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];

  /// 4 dp — elevated cards, dropdowns.
  static final List<BoxShadow> md = [
    BoxShadow(
      color: AppColors.withOpacity(Colors.black, 0.10),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: AppColors.withOpacity(Colors.black, 0.06),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  /// 8 dp — dialogs, popovers.
  static final List<BoxShadow> lg = [
    BoxShadow(
      color: AppColors.withOpacity(Colors.black, 0.12),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: AppColors.withOpacity(Colors.black, 0.08),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  /// 16 dp — modals, drawers, command palette.
  static final List<BoxShadow> xl = [
    BoxShadow(
      color: AppColors.withOpacity(Colors.black, 0.16),
      blurRadius: 32,
      offset: const Offset(0, 16),
    ),
    BoxShadow(
      color: AppColors.withOpacity(Colors.black, 0.10),
      blurRadius: 12,
      offset: const Offset(0, 6),
    ),
  ];

  // ---------------------------------------------------------------------------
  // Semantic aliases
  // ---------------------------------------------------------------------------

  static final List<BoxShadow> card = sm;
  static final List<BoxShadow> dropdown = md;
  static final List<BoxShadow> dialog = lg;
  static final List<BoxShadow> drawer = xl;

  // ---------------------------------------------------------------------------
  // Glow / colored shadow helper (e.g. primary CTA hover)
  // ---------------------------------------------------------------------------

  static List<BoxShadow> glow(Color color, {double opacity = 0.35}) => [
        BoxShadow(
          color: color.withValues(alpha: opacity),
          blurRadius: 12,
          spreadRadius: 0,
          offset: const Offset(0, 4),
        ),
      ];
}
