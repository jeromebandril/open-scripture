import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/presentation/widgets/ui/split_pane_view/split_pane_view.dart';
import '../../../bible_pane/presentation/widgets/bible_pane.dart';
import '../../../settings/presentation/widgets/bible_view_settings_provider.dart';
import '../pane_animation_constants.dart';
import '../state/multi_pane_manager_cubit.dart';

class MultiPaneContainer extends StatelessWidget {
  const MultiPaneContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PaneContainerDecoration(child: _PaneList());
  }
}

class _PaneContainerDecoration extends StatelessWidget {
  const _PaneContainerDecoration({required this.child});

  static const double _basePadding = 12;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final viewSettings = BibleViewSettingsScope.of(context);
    final viewColors = BibleViewSettingsScope.colorschemeOf(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: viewColors.backgroundColor,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: _basePadding + viewSettings.widthAdjustmentOffset,
        ),
        child: child,
      ),
    );
  }
}

class _PaneList extends StatelessWidget {
  const _PaneList();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MultiPaneManagerCubit>();
    final gap = BibleViewSettingsScope.of(context).splitscreenGap.toDouble();

    return BlocSelector<MultiPaneManagerCubit, PaneManagerState,
        (List<SplitPaneEntry<int>>, int?)>(
      selector: (state) => (state.panes, state.removingPaneId),
      builder: (context, data) {
        final (panes, removingPaneId) = data;

        return SplitPaneView<int>(
          entries: panes,
          removingId: removingPaneId,
          gap: gap,
          moveDuration: kPaneSwapDuration,
          transitionDuration: kPaneAddDuration,
          curve: kPaneAnimationCurve,
          onResize: (leftId, rightId, deltaFactor) {
            cubit.resizeAdjacentPanes(
              leftPaneId: leftId,
              rightPaneId: rightId,
              deltaFactor: deltaFactor,
            );
          },
          paneBuilder: (context, id) => Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) => cubit.setActive(id),
            child: BiblePane(
              uniqueId: id,
              blocComponents: cubit.paneBlocsFor(id),
            ),
          ),
        );
      },
    );
  }
}
