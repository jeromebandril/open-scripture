import 'package:flutter/material.dart';

/// Widgets wrapped in this will suppress global shortcuts.
class ShortcutsScopeSuppressed extends InheritedWidget {
  const ShortcutsScopeSuppressed({super.key, required super.child});

  static bool isSuppressed(BuildContext context) {
    // return context .dependOnInheritedWidgetOfExactType<ShortcutsScopeSuppressed>() !=
    return context.getElementForInheritedWidgetOfExactType<
            ShortcutsScopeSuppressed>() !=
        null;
  }

  @override
  bool updateShouldNotify(_) => false;
}
