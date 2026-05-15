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
    final isEditing =
        FocusManager.instance.primaryFocus?.context?.widget is EditableText;
    if (isEditing && !_isModifierCombo()) return false;

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
    final pressed = HardwareKeyboard.instance.logicalKeysPressed;
    for (final entry in appCommandShortcuts.entries) {
      if (_activatorMatches(entry.value, event, pressed)) return entry.key;
    }
    return null;
  }

  bool _activatorMatches(
    SingleActivator a,
    KeyEvent event,
    Set<LogicalKeyboardKey> pressed,
  ) {
    if (event.logicalKey != a.trigger) return false;
    if (!a.includeRepeats && event is KeyRepeatEvent) return false;

    bool mod(bool required, LogicalKeyboardKey l, LogicalKeyboardKey r) =>
        required == (pressed.contains(l) || pressed.contains(r));

    return mod(a.control, LogicalKeyboardKey.controlLeft,
            LogicalKeyboardKey.controlRight) &&
        mod(a.shift, LogicalKeyboardKey.shiftLeft,
            LogicalKeyboardKey.shiftRight) &&
        mod(a.alt, LogicalKeyboardKey.altLeft, LogicalKeyboardKey.altRight) &&
        mod(a.meta, LogicalKeyboardKey.metaLeft, LogicalKeyboardKey.metaRight);
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
          final isEditing = FocusManager.instance.primaryFocus?.context?.widget
              is EditableText;
          if (!isEditing) _root.requestFocus();
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
