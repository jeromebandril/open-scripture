import 'package:flutter/material.dart';

class ShortcutFocusScope extends InheritedWidget {
  const ShortcutFocusScope({
    super.key,
    required this.root,
    required this.search,
    required this.history,
    required super.child,
  });

  final FocusNode root;
  final FocusNode search;
  final FocusNode history;

  static ShortcutFocusScope of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<ShortcutFocusScope>();
    assert(
        result != null,
        'No ShortcutFocusScope found in context. '
        'Ensure ShortcutsHost is an ancestor of this widget.');
    return result!;
  }

  // Nodes never change identity after initState, so no rebuild needed.
  @override
  bool updateShouldNotify(ShortcutFocusScope old) => false;
}
