import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/presentation/cubit/fullscreen_cubit.dart';
import '../../../../../shared/presentation/cubit/toolbar_cubit.dart';
import '../../../../customizer/presentation/cubit/customizer_cubit.dart';
import '../../../../customizer/presentation/models/bible_pane_general_theme.dart';
import '../../../bible_pane/presentation/widgets/bible_pane.dart';
import '../cubit/pane_manager_cubit.dart';

class MultipleBiblePanes extends StatelessWidget {
  const MultipleBiblePanes({super.key});

  @override
  Widget build(BuildContext context) {
    final enableCustom = context.select(
      (CustomizerCubit c) => c.state.pane.enableCustomTheme,
    );
    final gap = context.select(
      (CustomizerCubit c) => c.state.pane.splitscreenGap,
    );
    final offset = context.select(
      (CustomizerCubit c) => c.state.pane.widthAdjustmentOffset,
    );
    final showDivider = context.select(
      (CustomizerCubit c) => c.state.pane.showSplitscreenDivider,
    );
    final isFullscreen = context.select((FullscreenCubit f) => f.state);
    final showMenuBar = context.select((ToolbarCubit t) => t.state);

    return BlocBuilder<PaneManagerCubit, PaneManagerState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.fromLTRB(12 + offset, 0, 12 + offset, 0),
          decoration: BoxDecoration(
            borderRadius: isFullscreen && !showMenuBar
                ? null
                : const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
            color: enableCustom
                ? Theme.of(context)
                    .extension<BiblePaneGeneralTheme>()!
                    .backgroundColor
                : Theme.of(context).colorScheme.surface,
          ),
          child: Row(
            spacing: gap.toDouble(),
            children: [
              for (int i = 0; i < state.panes.length; i++) ...[
                Expanded(
                  child: Listener(
                    behavior: HitTestBehavior.opaque,
                    onPointerDown: (_) => context
                        .read<PaneManagerCubit>()
                        .setActive(state.panes[i].id),
                    child: BiblePane(
                      uniqueId: state.panes[i].id,
                      blocComponents: context
                          .read<PaneManagerCubit>()
                          .paneBlocsFor(state.panes[i].id),
                    ),
                  ),
                ),
                if (i != state.panes.length - 1 && showDivider)
                  const VerticalDivider(width: 1)
              ]
            ],
          ),
        );
      },
    );
  }

  // void moveFocusRight(context) {
  //   print("> Splitviewer: change focus to RIGHT");
  //   BlocProvider.of<SplitScreenBloc>(context).add(
  //     const SplitScreenMoveFocus(direction: 'RIGHT'),
  //   );
  // }

  // void moveFocusLeft(context) {
  //   print("> Splitviewer: change focus to LEFT");
  //   BlocProvider.of<SplitScreenBloc>(context).add(
  //     const SplitScreenMoveFocus(direction: 'LEFT'),
  //   );
  // }

  // void setFocus(id, context) {
  //   print("> Splitviewer: change focus to $id");
  //   BlocProvider.of<SplitScreenBloc>(context).add(
  //     SplitScreenMoveFocus(id: id),
  //   );
  // }
}
