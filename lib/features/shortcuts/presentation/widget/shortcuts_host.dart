import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/presentation/cubit/fullscreen_cubit.dart';
import '../../../../shared/presentation/cubit/history_visibility_cubit.dart';
import '../../../../shared/presentation/cubit/toolbar_cubit.dart';
import '../../../b_searchbar/presenter/bloc/b_searchbar_bloc.dart';
import '../../../bible_display/split_screen/presenter/cubit/pane_manager_cubit.dart';
import '../models/app_command_dispatcher.dart';
import '../models/app_command_intent.dart';
import '../models/app_command_shortcuts.dart';

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

class ShortcutsHost extends StatelessWidget {
  const ShortcutsHost({
    super.key,
    required this.rootFocusNode,
    required this.child,
    required this.searchFocusNode,
    required this.historyFocusNode,
  });

  final FocusNode rootFocusNode;
  final Widget child;
  final FocusNode searchFocusNode;
  final FocusNode historyFocusNode;

  @override
  Widget build(BuildContext context) {
    final dispatcher = AppCommandDispatcher(
      paneManagerCubit: context.read<PaneManagerCubit>(),
      searchbarBloc: context.read<BSearchbarBloc>(),
      historyVisibilityCubit: context.read<HistoryVisibilityCubit>(),
      toolbarCubit: context.read<ToolbarCubit>(),
      fullscreenCubit: context.read<FullscreenCubit>(),
      rootFocusNode: rootFocusNode,
      searchFocusNode: searchFocusNode,
      historyFocusNode: historyFocusNode,
    );

    final actions = <Type, Action<Intent>>{
      AppCommandIntent: CallbackAction<AppCommandIntent>(
        onInvoke: (intent) {
          dispatcher.dispatch(intent.command);
          return null;
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
          shortcuts: buildShortcutIntentMap(appCommandShortcuts),
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
