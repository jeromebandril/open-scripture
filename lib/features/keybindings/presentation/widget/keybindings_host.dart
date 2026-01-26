import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_smyrna_bible_v2/core/presentation/cubit/fullscreen_cubit.dart';
import 'package:the_smyrna_bible_v2/core/presentation/cubit/toolbar_cubit.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_pane/presentation/bloc/bible_pane_bloc.dart';
import '../../../bible_display/split_screen/presenter/cubit/pane_manager_cubit.dart';
import '../../domain/app_command.dart';
import '../models/intents.dart';

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

Map<ShortcutActivator, Intent> buildShortcutIntentMap(
  Map<AppCommand, SingleActivator> source,
) {
  final result = <ShortcutActivator, Intent>{};

  for (final entry in source.entries) {
    result[entry.value] = AppCommandIntent(entry.key);
  }

  return result;
}

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
    // Map intent -> action
    final actions = <Type, Action<Intent>>{
      AppCommandIntent: CallbackAction<AppCommandIntent>(
        onInvoke: (intent) {
          switch (intent.command) {
            case AppCommand.focusSearch:
              searchFocusNode.requestFocus();
              return;
            case AppCommand.toggleToolbar:
              context.read<ToolbarCubit>().toggleVisibility();
              return;
            case AppCommand.toggleFullscreen:
              context.read<FullscreenCubit>().toggle();
              return;
            case AppCommand.prevVerse:
              final activeBloc = context.read<PaneManagerCubit>().activeBloc();
              if (activeBloc.state.reference == null) return;
              final ref = activeBloc.state.reference!;
              if (ref.verseStart == 1) return;

              activeBloc.add(
                BiblePaneJustChangeRef(
                    ref: ref.copyWith(
                  verseStart: (ref.verseStart ?? 1) - 1,
                  verseEnd: null,
                )),
              );
              return;
            case AppCommand.nextVerse:
              final activeBloc = context.read<PaneManagerCubit>().activeBloc();
              if (activeBloc.state.reference == null) return;
              final ref = activeBloc.state.reference!;
              // TODO: add to state the number of verses
              // currently relying on last segment verse number (if it is ordered)
              if (ref.verseStart ==
                  activeBloc.state.segments.last.ref.verseStart) return;

              activeBloc.add(
                BiblePaneJustChangeRef(
                    ref: ref.copyWith(
                  verseStart: (ref.verseStart ?? 0) + 1,
                  verseEnd: null,
                )),
              );
              return;
            case AppCommand.nextPane:
              final panes = context.read<PaneManagerCubit>().state.panes;
              final activePaneId =
                  context.read<PaneManagerCubit>().state.activePaneId;
              final index = panes.indexWhere((p) => p.id == activePaneId);
              final nextIndex = index == panes.length - 1 ? 0 : index + 1;
              context.read<PaneManagerCubit>().setActive(nextIndex);

              return;
            case AppCommand.prevPane:
              final panes = context.read<PaneManagerCubit>().state.panes;
              final activePaneId =
                  context.read<PaneManagerCubit>().state.activePaneId;
              final index = panes.indexWhere((p) => p.id == activePaneId);
              final nextIndex = index == 0 ? panes.length - 1 : index - 1;
              context.read<PaneManagerCubit>().setActive(nextIndex);

              return;

            case AppCommand.changeBible:
              final active = context.read<PaneManagerCubit>().activeBloc();
              active.add(BiblePaneCloseBible());
            default:
              return;
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
