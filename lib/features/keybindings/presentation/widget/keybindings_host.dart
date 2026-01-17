import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_smyrna_bible_v2/core/presentation/cubit/fullscreen_cubit.dart';
import 'package:the_smyrna_bible_v2/core/presentation/cubit/toolbar_cubit.dart';
import '../../domain/app_command.dart';
import 'intents.dart';

// Convert to stateful widget and uncomment the following lines
// to debug the focus scope
//
// @override
// void initState() {
//   super.initState();
//   FocusManager.instance.addListener(_logFocus);
// }

// void _logFocus() {
//   final pf = FocusManager.instance.primaryFocus;
//   debugPrint('primaryFocus changed: $pf / ${pf?.debugLabel}');
// }

// @override
// void dispose() {
//   FocusManager.instance.removeListener(_logFocus);
//   super.dispose();
// }

class ShortcutHost extends StatelessWidget {
  const ShortcutHost({
    super.key,
    required this.rootFocusNode,
    required this.child,
    required this.searchFocusNode,
  });

  final FocusNode rootFocusNode;
  final Widget child;
  final FocusNode searchFocusNode;

  @override
  Widget build(BuildContext context) {
    // Map physical keys -> intent
    final shortcuts = <ShortcutActivator, Intent>{
      // Ctrl+L (Windows/Linux)
      const SingleActivator(LogicalKeyboardKey.keyL, control: true):
          const AppCommandIntent(AppCommand.focusSearch),

      const SingleActivator(LogicalKeyboardKey.keyT, alt: true):
          const AppCommandIntent(AppCommand.toggleToolbar),

      const SingleActivator(LogicalKeyboardKey.keyF, control: true):
          const AppCommandIntent(AppCommand.toggleFullscreen),

      // Cmd+L (macOS)
      const SingleActivator(LogicalKeyboardKey.keyL, meta: true):
          const AppCommandIntent(AppCommand.focusSearch),
    };

    // Map intent -> action
    final actions = <Type, Action<Intent>>{
      AppCommandIntent: CallbackAction<AppCommandIntent>(
        onInvoke: (intent) {
          switch (intent.command) {
            case AppCommand.focusSearch:
              searchFocusNode.requestFocus();
              return null;
            case AppCommand.toggleToolbar:
              context.read<ToolbarCubit>().toggleVisibility();
              return null;
            case AppCommand.toggleFullscreen:
              context.read<FullscreenCubit>().toggle();
            default:
              return null;
          }
        },
      ),
    };

    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: () {
        // final primary = FocusManager.instance.primaryFocus;
        // If the user is currently editing text, do not steal focus.
        // final isEditingText = primary?.context?.widget is EditableText;
        // if (isEditingText) return;

        // If focus is already within this subtree, you can skip.
        // Minimal safe rule: ensure we always have a focus anchor.
        //if (!rootFocusNode.hasFocus) {
        rootFocusNode.requestFocus();
        //}
      },
      child: Actions(
        actions: actions,
        child: Shortcuts(
          shortcuts: shortcuts,
          child: Focus(
            focusNode: rootFocusNode,
            autofocus: true,
            child: child,
          ),
        ),
      ),
    );
  }
}
