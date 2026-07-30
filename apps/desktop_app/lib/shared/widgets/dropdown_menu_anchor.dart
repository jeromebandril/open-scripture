import 'package:flutter/material.dart';
import '../../app/widgets/app_reveal_animation.dart';
import '../constants.dart';
import '../design_system/design_system.dart';

/// A reusable widget that wraps any [trigger] and pops an overlay menu
/// near it, animated with [AppRevealAnimation] (for consistent animation
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
/// ## Positioning
///
/// The menu measures the real space above and below [trigger] inside the
/// nearest [Overlay] and opens on whichever side fits, shrinking itself to
/// the available space if neither side fully fits. This works whether the
/// trigger sits inside the app window directly or inside a constrained
/// container such as a dialog, since the space is measured from the
/// trigger's actual position, not from the screen size alone.
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
    required this.menuHeight,
    this.menuWidthFraction = 0.25,
    // this.menuHeightFraction = 0.4,
    // Layout
    this.menuGap = 5.0,
    this.menuAlignment = Alignment.topLeft,
    //  Behaviour
    this.dismissOnOutsideTap = true,
    //  Decoration
    this.menuPadding,
    this.menuColor,
    this.onDismiss,
  });

  /// Controls menu open/close from outside this widget.
  final ValueNotifier<bool> menuVisible;

  final VoidCallback? onDismiss;

  /// The widget that acts as the anchor
  final Widget trigger;

  final Widget menuContent;

  final double? menuWidth;
  final double menuHeight;

  /// Fraction of screen width used when [menuWidth] is null.
  final double menuWidthFraction;

  /// Fraction of screen height used when [menuHeight] is null.
  // final double menuHeightFraction;

  /// Vertical gap between the trigger and the menu.
  final double menuGap;

  /// Which corner of the menu aligns with [link].
  /// [Alignment.topLeft] keeps the menu left-aligned with the trigger.
  /// [Alignment.topRight] right-aligns it.
  final Alignment menuAlignment;

  final bool dismissOnOutsideTap;

  /// Override default menu container decoration.
  final EdgeInsetsGeometry? menuPadding;
  final Color? menuColor;

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
    final popupTheme = Theme.of(context).popupMenuTheme;

    final overlayWidth = info.overlaySize.width;
    final overlayHeight = info.overlaySize.height;

    final childOffset =
        MatrixUtils.transformPoint(info.childPaintTransform, Offset.zero);
    final childLeft = childOffset.dx;
    final childTop = childOffset.dy;
    final childBottom = childTop + info.childSize.height;

    final edgeMargin = AppSpacing.xl3;

    final spaceBelow =
        overlayHeight - childBottom - widget.menuGap - edgeMargin;
    final spaceAbove =
        childTop - kWindowsTitleBarHeight - widget.menuGap - edgeMargin;

    final fitsBelow = spaceBelow >= widget.menuHeight;
    final fitsAbove = spaceAbove >= widget.menuHeight;
    final openBelow = fitsBelow || (!fitsAbove && spaceBelow >= spaceAbove);

    final availableHeight = openBelow ? spaceBelow : spaceAbove;
    final resolvedHeight = widget.menuHeight
        .clamp(0.0, availableHeight > 0 ? availableHeight : 0.0)
        .toDouble();

    final resolvedWidth =
        widget.menuWidth ?? overlayWidth * widget.menuWidthFraction;

    var dx = widget.menuAlignment == Alignment.topRight
        ? info.childSize.width - resolvedWidth
        : 0.0;
    final absoluteLeft = childLeft + dx;
    if (absoluteLeft < edgeMargin) {
      dx += edgeMargin - absoluteLeft;
    } else if (absoluteLeft + resolvedWidth > overlayWidth - edgeMargin) {
      dx -= (absoluteLeft + resolvedWidth) - (overlayWidth - edgeMargin);
    }

    final dy = openBelow ? widget.menuGap : -widget.menuGap;
    final targetAnchor = openBelow ? Alignment.bottomLeft : Alignment.topLeft;
    final followerAnchor = openBelow ? Alignment.topLeft : Alignment.bottomLeft;

    final child = ConstrainedBox(
      constraints:
          BoxConstraints(maxWidth: resolvedWidth, maxHeight: resolvedHeight),
      child: Material(
        color: widget.menuColor ?? popupTheme.color,
        elevation: popupTheme.elevation ?? 4,
        shadowColor: popupTheme.shadowColor,
        shape: popupTheme.shape,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: widget.menuPadding ?? popupTheme.menuPadding!,
          child: SizedBox(width: resolvedWidth, child: widget.menuContent),
        ),
      ),
    );

    return Stack(
      children: [
        if (widget.dismissOnOutsideTap)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _dismiss,
            ),
          ),
        CompositedTransformFollower(
          link: _layerLink,
          targetAnchor: targetAnchor,
          followerAnchor: followerAnchor,
          offset: Offset(dx, dy),
          child: BlockSemantics(
            blocking: true,
            child: AppRevealAnimation(
              origin: _animOriginFromAlignment(),
              child: child,
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
