import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/bible_display/split_screen/presenter/models/split_pane_data.dart';

import '../../../../../shared/presentation/cubit/fullscreen_cubit.dart';
import '../../../../../shared/presentation/cubit/menubar_visibility_cubit.dart';
import '../../../../../shared/theme/tokens.dart';
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
    final showMenuBar = context.select((MenubarCubit t) => t.state);

    return BlocSelector<PaneManagerCubit, PaneManagerState,
        List<PaneDescriptor>>(
      selector: (PaneManagerState state) => state.panes,
      builder: (context, panes) {
        return Container(
          padding: EdgeInsets.fromLTRB(12 + offset, 0, 12 + offset, 0),
          decoration: BoxDecoration(
            borderRadius: isFullscreen && !showMenuBar
                ? null
                : const BorderRadius.only(
                    topLeft: Radius.circular(AppRadius.sm),
                    topRight: Radius.circular(AppRadius.sm),
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
              for (int i = 0; i < panes.length; i++) ...[
                Expanded(
                  child: Listener(
                    behavior: HitTestBehavior.translucent,
                    onPointerDown: (_) =>
                        context.read<PaneManagerCubit>().setActive(panes[i].id),
                    child: BiblePane(
                      uniqueId: panes[i].id,
                      blocComponents: context
                          .read<PaneManagerCubit>()
                          .paneBlocsFor(panes[i].id),
                    ),
                  ),
                ),
                if (i != panes.length - 1 && showDivider)
                  const VerticalDivider(width: 1, thickness: 3)
              ]
            ],
          ),
        );
      },
    );
  }
}
