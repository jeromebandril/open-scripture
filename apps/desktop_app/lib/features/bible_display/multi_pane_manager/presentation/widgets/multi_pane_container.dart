import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/bible_display/multi_pane_manager/presentation/models/multi_pane_data.dart';
import '../../../../../core/app_state/fullscreen_cubit.dart';
import '../../../../../core/app_state/interface_visibility_cubit.dart';
import '../../../../../shared/theme/tokens.dart';
import '../../../../customizer/presentation/state/customizer_cubit.dart';
import '../../../../customizer/presentation/models/bible_pane_general_theme.dart';
import '../../../bible_pane/presentation/widgets/bible_pane.dart';
import '../state/multi_pane_manager_cubit.dart';

class MultiPaneContainer extends StatelessWidget {
  const MultiPaneContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return _PaneContainerDecoration(
      child: _PaneList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Decoration layer - rebuilds on theme/layout changes only.
// Isolated so pane list rebuilds don't thrash decoration and vice versa.
// ---------------------------------------------------------------------------
class _PaneContainerDecoration extends StatelessWidget {
  const _PaneContainerDecoration({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final enableCustom = context.select(
      (CustomizerCubit c) => c.state.pane.enableCustomTheme,
    );
    final offset = context.select(
      (CustomizerCubit c) => c.state.pane.widthAdjustmentOffset,
    );
    final isFullscreen = context.select((FullscreenCubit f) => f.state);
    final showMenuBar = context.select(
      (InterfaceVisibilityCubit i) => i.state.isToolbarVisible,
    );

    return DecoratedBox(
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
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12 + offset),
        child: child,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Pane list layer - rebuilds only when the pane list or divider flag changes.
// ---------------------------------------------------------------------------
class _PaneList extends StatelessWidget {
  const _PaneList();

  @override
  Widget build(BuildContext context) {
    final gap = context.select(
      (CustomizerCubit c) => c.state.pane.splitscreenGap,
    );
    final showDivider = context.select(
      (CustomizerCubit c) => c.state.pane.showSplitscreenDivider,
    );

    return BlocSelector<MultiPaneManagerCubit, PaneManagerState,
        List<PaneDescriptor>>(
      selector: (state) => state.panes,
      builder: (context, panes) {
        final cubit = context.read<MultiPaneManagerCubit>();

        return Row(
          spacing: gap.toDouble(),
          children: [
            for (int i = 0; i < panes.length; i++) ...[
              Expanded(
                // ValueKey ensures Flutter remounts the subtree when a pane
                // moves position (swap) or is removed, preventing stale bloc
                // references from being reused across identities.
                key: ValueKey(panes[i].id),
                child: Listener(
                  behavior: HitTestBehavior.translucent,
                  onPointerDown: (_) => cubit.setActive(panes[i].id),
                  child: BiblePane(
                    uniqueId: panes[i].id,
                    blocComponents: cubit.paneBlocsFor(panes[i].id),
                  ),
                ),
              ),
              if (i != panes.length - 1 && showDivider)
                VerticalDivider(
                  key: ValueKey('divider_$i'),
                  width: 1,
                  thickness: 3,
                ),
            ],
          ],
        );
      },
    );
  }
}
