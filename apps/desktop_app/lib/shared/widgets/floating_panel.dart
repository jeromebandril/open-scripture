import 'package:flutter/material.dart';
import 'package:open_scripture/app/widgets/app_reveal_animation.dart';
import 'package:open_scripture/shared/design_system/design_system.dart';

/// A panel that floats at an absolute position inside a [Stack].
///
/// Designed for fullscreen mode overlays (history list, inspector, palette…)
/// that need to appear/disappear without being removed from the tree.
///
/// Must be a direct child of a [Stack] (or [LayoutBuilder] ->[Stack]).
///
/// ## Visibility
/// [visible] drives both [Visibility] (with [maintainState] /
/// [maintainFocusability]) and [AppRevealAnimation], so toggling it gives
/// the fade animation automatically.
///
/// ## Positioning
/// Supply any combination of [top] / [bottom] / [left] / [right] - exactly
/// like [Positioned]. Omit all four to let the Stack place it normally.
/// Combine with [alignment] to center horizontally / vertically within the
/// positioned slot (default: [Alignment.topCenter]).
///
/// ## Size
/// [width] and [height] are optional. When omitted the panel sizes itself
/// to its child.
///
/// ## Usage
/// ```dart
/// Stack(
///   children: [
///     MainCanvas(),
///     FloatingPanel(
///       visible: showHistory,
///       top: screen.height * 0.08 + 100,
///       left: 0,
///       right: 0,
///       width: 350,
///       child: HistoryList(),
///     ),
///   ],
/// )
/// ```
class FloatingPanel extends StatelessWidget {
  const FloatingPanel({
    super.key,
    required this.visible,
    required this.child,
    // Positioning
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.alignment = Alignment.topCenter,
    // Size
    this.width,
    this.height,
    // Visibility behaviour
    this.maintainState = true,
    this.maintainFocusability = true,
    // Decoration
    this.padding = const EdgeInsets.all(6),
    this.decoration,
    // Animation
    // this.animationDuration = const Duration(milliseconds: 140),
    // this.animationCurve = Curves.easeOut,
  });

  /// Shows or hides the panel. Drives both [Visibility] and the fade animation.
  final bool visible;

  final Widget child;

  // (mirrors [Positioned] parameters)
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  /// Alignment within the positioned slot.
  /// [Alignment.topCenter] replicates your original Align + Positioned pattern.
  final AlignmentGeometry alignment;

  final double? width;
  final double? height;

  // Visibility behaviour
  final bool maintainState;
  final bool maintainFocusability;

  // Decoration
  final EdgeInsetsGeometry padding;

  /// Pass a custom [BoxDecoration] to override.
  final BoxDecoration? decoration;

  // Animation
  /// (delegate to [AppRevealAnimation])
  // final Duration animationDuration;
  // final Curve animationCurve;

  @override
  Widget build(BuildContext context) {
    final resolvedDecoration = decoration ??
        BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border:
                BoxBorder.all(width: 4, color: Theme.of(context).dividerColor));

    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Visibility(
        visible: visible,
        maintainState: maintainState,
        maintainFocusability: maintainFocusability,
        maintainAnimation: true, // keep animation ticking while hidden
        child: Align(
          alignment: alignment,
          child: AppRevealAnimation(
            visible: visible,
            // duration: animationDuration,
            // curve: animationCurve,
            child: Container(
              width: width,
              height: height,
              padding: padding,
              decoration: resolvedDecoration,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
