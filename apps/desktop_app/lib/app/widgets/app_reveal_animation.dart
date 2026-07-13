import 'package:flutter/material.dart';

enum AnimationOrigin {
  topCenter,
  topLeft,
  topRight,
  center,
}

/// A single source-of-truth reveal animation for the app.
/// Every animated widget uses the same fade + subtle scale + slight slide-up.
///
/// Supports two modes:
///
/// 1. **Mount mode** (default, [visible] is null):
///    The animation plays forward once when the widget is first mounted.
///    Use this inside overlays/portals that are added/removed from the tree.
///
/// 2. **Visibility mode** ([visible] is provided):
///    The widget stays mounted. The animation plays forward when [visible]
///    becomes true and reverses when it becomes false.
///    Use this for persistent widgets like a search bar that toggle in/out.
///
/// ```dart
/// // Mount mode - overlay content:
/// AppRevealAnimation(child: MyMenu())
///
/// // Visibility mode - persistent widget:
/// AppRevealAnimation(visible: _isOpen, child: MySearchBar())
/// ```
class AppRevealAnimation extends StatefulWidget {
  const AppRevealAnimation({
    super.key,
    required this.child,
    this.visible,
    this.origin = AnimationOrigin.topCenter,
    this.duration = const Duration(milliseconds: 120),
    this.reverseDuration = const Duration(milliseconds: 80),
    this.curve = Curves.easeOutQuint,
    this.reverseCurve = Curves.easeInCubic,
  });

  final Widget child;

  /// When null the animation plays once on mount (overlay/portal use-case).
  /// When provided the animation tracks this boolean (persistent widget use-case).
  final bool? visible;

  /// Where the widget "grows from". Affects scale and slide direction.
  final AnimationOrigin origin;

  final Duration duration;
  final Duration reverseDuration;
  final Curve curve;
  final Curve reverseCurve;

  @override
  State<AppRevealAnimation> createState() => _AppRevealAnimationState();
}

class _AppRevealAnimationState extends State<AppRevealAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.reverseDuration,
    );

    _buildAnimations();

    if (widget.visible == null) {
      _ctrl.forward();
    } else {
      _ctrl.value = widget.visible! ? 1.0 : 0.0;
    }
  }

  void _buildAnimations() {
    final forward = CurvedAnimation(
      parent: _ctrl,
      curve: widget.curve,
      reverseCurve: widget.reverseCurve,
    );

    _fade = forward;

    _scale = Tween<double>(begin: 0.96, end: 1.0).animate(forward);

    // Slide: origin-aware so the widget expands in the natural direction.
    _slide = Tween<Offset>(
      begin: _slideBegin(widget.origin),
      end: Offset.zero,
    ).animate(forward);
  }

  static Offset _slideBegin(AnimationOrigin origin) {
    switch (origin) {
      case AnimationOrigin.topCenter:
      case AnimationOrigin.topLeft:
      case AnimationOrigin.topRight:
        return const Offset(0, -0.03);
      case AnimationOrigin.center:
        return Offset.zero;
    }
  }

  static Alignment _scaleAlignment(AnimationOrigin origin) {
    switch (origin) {
      case AnimationOrigin.topCenter:
        return Alignment.topCenter;
      case AnimationOrigin.topLeft:
        return Alignment.topLeft;
      case AnimationOrigin.topRight:
        return Alignment.topRight;
      case AnimationOrigin.center:
        return Alignment.center;
    }
  }

  @override
  void didUpdateWidget(AppRevealAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.curve != oldWidget.curve ||
        widget.reverseCurve != oldWidget.reverseCurve) {
      _buildAnimations();
    }

    if (widget.visible != null && widget.visible != oldWidget.visible) {
      if (widget.visible!) {
        _ctrl.forward();
      } else {
        _ctrl.reverse();
      }
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alignment = _scaleAlignment(widget.origin);

    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        alignment: alignment,
        child: SlideTransition(
          position: _slide,
          child: widget.child,
        ),
      ),
    );
  }
}
