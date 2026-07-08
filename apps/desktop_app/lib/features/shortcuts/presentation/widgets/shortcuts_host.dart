import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/app_command.dart';
import '../models/app_command_shortcuts.dart';
import '../models/ui_effect_dispatcher.dart';
import '../state/shortcuts_cubit.dart';
import 'shortcuts_focus_scope.dart';
import 'shortcuts_scope_suppressed.dart';

class ShortcutsHost extends StatefulWidget {
  const ShortcutsHost({super.key, required this.child});
  final Widget child;

  @override
  State<ShortcutsHost> createState() => _ShortcutsHostState();
}

class _ShortcutsHostState extends State<ShortcutsHost> {
  // FocusNode ownership lives here — disposed with this widget
  late final FocusNode _root;
  late final FocusNode _search;
  late final FocusNode _history;
  late final UiEffectDispatcher _uiEffectDispatcher;

  @override
  void initState() {
    super.initState();
    _root = FocusNode(debugLabel: 'root');
    _search = FocusNode(debugLabel: 'searchbar');
    _history = FocusNode(debugLabel: 'history');
    _uiEffectDispatcher = UiEffectDispatcher(
      context: context,
      rootFocusNode: _root,
      searchFocusNode: _search,
      historyFocusNode: _history,
    );
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
    FocusManager.instance.addListener(_ensureFocusAnchor);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    FocusManager.instance.removeListener(_ensureFocusAnchor);
    _root.dispose();
    _search.dispose();
    _history.dispose();
    super.dispose();
  }

  // Always keep a focus anchor
  void _ensureFocusAnchor() {
    if (FocusManager.instance.primaryFocus == null) {
      _root.requestFocus();
    }
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) return false;

    // Guard 1: suppress inside modal overlays
    if (_isInsideModalScope()) return false;

    // Guard 2: resolve to a command
    final command = _resolveCommand(event);
    if (command == null) return false;

    // Guard 3: don't steal plain keypresses from text fields
    if (_isEditing() && !_isModifierCombo()) return false;

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!mounted) return false;
    context.read<ShortcutsCubit>().executeCommand(command);
    _uiEffectDispatcher.emitEffectFor(command);
    // });

    return true;
  }

  bool _isInsideModalScope() {
    final focus = FocusManager.instance.primaryFocus;
    final context = focus?.context;

    if (context == null) return false;
    if (!context.mounted) return false;

    return ShortcutsScopeSuppressed.isSuppressed(context);
  }

  bool _isModifierCombo() {
    final pressed = HardwareKeyboard.instance.logicalKeysPressed;
    return pressed.contains(LogicalKeyboardKey.controlLeft) ||
        pressed.contains(LogicalKeyboardKey.controlRight) ||
        pressed.contains(LogicalKeyboardKey.altLeft) ||
        pressed.contains(LogicalKeyboardKey.altRight) ||
        pressed.contains(LogicalKeyboardKey.metaLeft) ||
        pressed.contains(LogicalKeyboardKey.metaRight);
  }

  AppCommand? _resolveCommand(KeyEvent event) {
    for (final entry in appCommandShortcuts.entries) {
      final activator = entry.value;
      if (activator.accepts(event, HardwareKeyboard.instance)) {
        return entry.key;
      }
    }
    return null;
  }

  bool _isEditing() {
    final focus = FocusManager.instance.primaryFocus;
    final context = focus?.context;

    return context is Element &&
        context.mounted &&
        context.widget is EditableText;
  }

  @override
  Widget build(BuildContext context) {
    return ShortcutFocusScope(
      root: _root,
      search: _search,
      history: _history,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (!_isEditing()) _root.requestFocus();
        },
        child: Focus(
          focusNode: _root,
          autofocus: true,
          child: widget.child,
        ),
      ),
    );
  }
}
