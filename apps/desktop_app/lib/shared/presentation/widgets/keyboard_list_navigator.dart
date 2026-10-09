import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Wraps [child] and intercepts keyboard events to drive highlight
/// navigation through a list of [itemCount] items. Arrow keys move the
/// highlight, [selectKeys] confirms the highlighted item, both wrap by
/// default.
///
/// Highlight state is NOT owned here: the caller stores `highlightedIndex`
/// and gets it back via [onHighlightChanged]. Each caller decides its
/// own policy, this widget only decides what a keypress *means*.
///
/// Pass a [focusNode] when this widget's own subtree is what should
/// hold input focus (e.g. a standalone list opened by a shortcut).
/// Leave it null with [canRequestFocus] false when interception
/// should happen on an ancestor of some *other* focused widget
/// (e.g. a textfield)
class KeyboardListNavigator extends StatelessWidget {
  KeyboardListNavigator({
    super.key,
    required this.itemCount,
    required this.highlightedIndex,
    required this.onHighlightChanged,
    required this.child,
    this.onSelect,
    this.onEscape,
    this.active = true,
    this.wrap = true,
    this.focusNode,
    this.canRequestFocus = true,
    Set<LogicalKeyboardKey>? selectKeys,
    Set<LogicalKeyboardKey>? previousKeys,
    Set<LogicalKeyboardKey>? nextKeys,
  })  : selectKeys = selectKeys ??
            {
              LogicalKeyboardKey.enter,
              LogicalKeyboardKey.numpadEnter,
            },
        previousKeys = previousKeys ?? {LogicalKeyboardKey.arrowUp},
        nextKeys = nextKeys ?? {LogicalKeyboardKey.arrowDown};

  final int itemCount;
  final int highlightedIndex; // -1 == nothing highlighted
  final ValueChanged<int> onHighlightChanged;
  final Widget child;

  /// Fired with the highlighted index when a key in [selectKeys] is
  /// pressed. Not fired when there are no items or nothing is highlighted
  final ValueChanged<int>? onSelect;

  /// Fired on Escape. Pass null to let Escape pass through
  final VoidCallback? onEscape;

  /// Whether this navigator currently intercepts keys at all. Needed when
  /// the focused widget outlives the dropdown (e.g. a search field stays
  /// focused after its suggestion list closes).
  final bool active;

  final bool wrap;
  final FocusNode? focusNode;
  final bool canRequestFocus;

  final Set<LogicalKeyboardKey> selectKeys;
  final Set<LogicalKeyboardKey> previousKeys;
  final Set<LogicalKeyboardKey> nextKeys;

  int _stepped(int delta) {
    final next = highlightedIndex + delta;
    if (wrap) return next % itemCount;
    return next.clamp(0, itemCount - 1);
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent) return KeyEventResult.ignored;
    if (!active) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      if (onEscape == null) return KeyEventResult.ignored;
      onEscape!();
      return KeyEventResult.handled;
    }

    if (itemCount == 0) return KeyEventResult.ignored;

    if (previousKeys.contains(event.logicalKey)) {
      onHighlightChanged(_stepped(-1));
      return KeyEventResult.handled;
    }
    if (nextKeys.contains(event.logicalKey)) {
      onHighlightChanged(_stepped(1));
      return KeyEventResult.handled;
    }
    if (selectKeys.contains(event.logicalKey)) {
      if (highlightedIndex < 0 || highlightedIndex >= itemCount) {
        return KeyEventResult.ignored;
      }
      onSelect?.call(highlightedIndex);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focusNode,
      canRequestFocus: canRequestFocus,
      skipTraversal: !canRequestFocus,
      onKeyEvent: _handleKey,
      child: child,
    );
  }
}
