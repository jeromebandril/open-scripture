import 'package:flutter/material.dart';
import 'package:open_scripture/app/widgets/app_reveal_animation.dart';

/// A reusable widget that wraps any [trigger] and pops an overlay menu
/// below it, animated with [AppRevealAnimation] (for consistent animation
/// in different widgets).
///
/// ## Trigger control
///
/// Pass a [ValueNotifier<bool>] as [menuVisible]. Whoever owns the notifier
/// (a Cubit listener, a keyboard shortcut handler, a simple setState, …)
/// just writes `notifier.value = true/false` and this widget will react automatically.
///
/// ```dart
/// // In parent state / BlocListener:
/// final _toolMenuVisible = ValueNotifier<bool>(false);
///
/// // In build:
/// DropdownMenuAnchor(
///   menuVisible: _toolMenuVisible,
///   trigger: CustomIconButton(..., onTap: () => _toolMenuVisible.value = !_toolMenuVisible.value),
///   menuContent: const ToolbarMenu(),
/// )
///
/// // From a keyboard shortcut or Cubit:
/// _toolMenuVisible.value = state.isToolMenuVisible;
/// ```
///
/// ## Size
///
/// Supply absolute pixel sizes with [menuWidth] / [menuHeight].
/// If you omit them the widget falls back to responsive fractions of the
/// screen via [menuWidthFraction] / [menuHeightFraction].
///
/// ## Dismiss on outside tap
///
/// [dismissOnOutsideTap] defaults to true. Set it to false if you manage
/// dismissal entirely from the [menuVisible] notifier yourself.
class DropdownMenuAnchor extends StatefulWidget {
  const DropdownMenuAnchor({
    super.key,
    required this.menuVisible,
    required this.trigger,
    required this.menuContent,
    // Size
    this.menuWidth,
    this.menuHeight,
    this.menuWidthFraction = 0.25,
    this.menuHeightFraction = 0.4,
    // Layout
    this.menuGap = 5.0,
    this.menuAlignment = Alignment.topLeft,
    //  Behaviour
    this.dismissOnOutsideTap = true,
    //  Decoration
    this.menuDecoration,
    this.menuPadding = const EdgeInsets.all(8),
    this.onDismiss,
  });

  /// Controls menu open/close from outside this widget.
  final ValueNotifier<bool> menuVisible;

  final VoidCallback? onDismiss;

  /// The widget that acts as the anchor
  final Widget trigger;

  final Widget menuContent;

  final double? menuWidth;
  final double? menuHeight;

  /// Fraction of screen width used when [menuWidth] is null.
  final double menuWidthFraction;

  /// Fraction of screen height used when [menuHeight] is null.
  final double menuHeightFraction;

  /// Vertical gap between the trigger bottom and the menu top.
  final double menuGap;

  /// Which corner of the menu aligns with [link].
  /// [Alignment.topLeft] keeps the menu left-aligned with the trigger.
  /// [Alignment.topRight] right-aligns it.
  final Alignment menuAlignment;

  final bool dismissOnOutsideTap;

  /// Override default menu container decoration.
  final BoxDecoration? menuDecoration;

  final EdgeInsetsGeometry menuPadding;

  @override
  State<DropdownMenuAnchor> createState() => _DropdownMenuAnchorState();
}

class _DropdownMenuAnchorState extends State<DropdownMenuAnchor> {
  final _controller = OverlayPortalController();
  final _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    widget.menuVisible.addListener(_onVisibilityChanged);
  }

  @override
  void didUpdateWidget(DropdownMenuAnchor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.menuVisible != widget.menuVisible) {
      oldWidget.menuVisible.removeListener(_onVisibilityChanged);
      widget.menuVisible.addListener(_onVisibilityChanged);
    }
  }

  @override
  void dispose() {
    widget.menuVisible.removeListener(_onVisibilityChanged);
    super.dispose();
  }

  void _onVisibilityChanged() {
    widget.menuVisible.value ? _controller.show() : _controller.hide();
  }

  void _dismiss() {
    if (widget.onDismiss != null) {
      widget.onDismiss!(); // caller decides what "dismiss" means
    } else {
      widget.menuVisible.value = false; // fallback for non cubit/bloc usage
    }
  }

  Widget _buildOverlayChild(BuildContext context, OverlayChildLayoutInfo info) {
    final screen = MediaQuery.sizeOf(context);

    final resolvedWidth =
        widget.menuWidth ?? screen.width * widget.menuWidthFraction;
    final resolvedHeight =
        widget.menuHeight ?? screen.height * widget.menuHeightFraction;

    // Horizontal offset for right-alignment.
    final dx = widget.menuAlignment == Alignment.topRight
        ? info.childSize.width - resolvedWidth
        : 0.0;
    final dy = info.childSize.height + widget.menuGap;

    final menuDecoration = widget.menuDecoration ??
        BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        );

    return Stack(
      children: [
        //
        // Outside-tap dismissal
        //
        if (widget.dismissOnOutsideTap)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _dismiss,
            ),
          ),
        //
        // Floating menu
        //
        CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(dx, dy),
          child: BlockSemantics(
            blocking: true,
            child: AppRevealAnimation(
              origin: _animOriginFromAlignment(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: resolvedWidth,
                  maxHeight: resolvedHeight,
                ),
                child: Container(
                  width: resolvedWidth,
                  padding: widget.menuPadding,
                  decoration: menuDecoration,
                  child: widget.menuContent,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  AnimationOrigin _animOriginFromAlignment() {
    switch (widget.menuAlignment) {
      case Alignment.topLeft:
        return AnimationOrigin.topLeft;
      case Alignment.topRight:
        return AnimationOrigin.topRight;
      case Alignment.topCenter:
        return AnimationOrigin.topCenter;
      case Alignment.center:
        return AnimationOrigin.center;
      default:
        return AnimationOrigin.topCenter;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: OverlayPortal.overlayChildLayoutBuilder(
        controller: _controller,
        overlayChildBuilder: _buildOverlayChild,
        child: widget.trigger,
      ),
    );
  }
}
