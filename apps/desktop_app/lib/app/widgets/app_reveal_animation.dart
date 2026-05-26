import 'package:flutter/material.dart';

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
    this.duration = const Duration(milliseconds: 80),
    this.curve = Curves.easeOut,
    this.reverseCurve = Curves.easeIn,
  });

  final Widget child;

  /// When null the animation plays once on mount (overlay/portal use-case).
  /// When provided the animation tracks this boolean (persistent widget use-case).
  final bool? visible;

  final Duration duration;
  final Curve curve;
  final Curve reverseCurve;

  @override
  State<AppRevealAnimation> createState() => _AppRevealAnimationState();
}

class _AppRevealAnimationState extends State<AppRevealAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.duration,
    );

    final curved = CurvedAnimation(
      parent: _ctrl,
      curve: widget.curve,
      // reverseCurve: widget.reverseCurve,
    );

    _fade = curved;
    _scale = Tween<double>(begin: 0.97, end: 1.0).animate(curved);
    _slide = Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero)
        .animate(curved);

    if (widget.visible == null) {
      _ctrl.forward();
    } else {
      _ctrl.value = widget.visible! ? 1.0 : 0.0;
    }
  }

  @override
  void didUpdateWidget(AppRevealAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != null && widget.visible != oldWidget.visible) {
      widget.visible! ? _ctrl.forward() : _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        alignment: Alignment.topCenter,
        child: SlideTransition(
          position: _slide,
          child: widget.child,
        ),
      ),
    );
  }
}
