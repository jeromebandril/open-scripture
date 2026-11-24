import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../app/widgets/app_reveal_animation.dart';
import '../../../../../core/di/injection_container.dart' as di;
import '../../../../../shared/design_system/design_system.dart';
import '../../../../../shared/enums/bible_repository_type.dart';
import '../../../../../shared/presentation/widgets/ui/b_container_tab_bar.dart';
import '../../../bible_pane/presentation/state/bible_pane_bloc.dart';
import '../../../bible_pane/presentation/widgets/pane_info.dart';
import '../../../multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import '../cubit/bible_selector_cubit.dart';
import 'shared_catalog_selector.dart';

class BibleSelector extends StatelessWidget {
  const BibleSelector({this.cubit, super.key});

  final BibleSelectorCubit? cubit;

  @override
  Widget build(BuildContext context) {
    // if cubit is injected
    if (cubit != null) {
      return BlocProvider.value(
        value: cubit!,
        child: const _BibleSelectorView(),
      );
    }

    return BlocProvider(
      create: (context) {
        final pane = context.read<BiblePaneBloc>().state;
        return di.sl<BibleSelectorCubit>(
          param1: pane.openedBiblesIds,
          param2: pane.repoType,
        );
      },
      child: const _BibleSelectorView(),
    );
  }
}

class _BibleSelectorView extends StatelessWidget {
  const _BibleSelectorView();

  static const _repoTypes = BibleRepositoryType.platformEnabled;
  static const _animationDuration = Duration(milliseconds: 300);

  int _initialTabIndex(BuildContext context) {
    final repoType = context.read<BiblePaneBloc>().state.repoType;
    final index = _repoTypes.indexOf(repoType);
    return index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    return AppRevealAnimation(
      origin: AnimationOrigin.center,
      duration: _animationDuration,
      reverseDuration: _animationDuration,
      child: _Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.xl,
          children: [
            const _Header(),
            Expanded(
              child: BContainerTabBar(
                initialIndex: _initialTabIndex(context),
                tabs: [for (final type in _repoTypes) type.label],
                views: [
                  for (final type in _repoTypes)
                    SharedCatalogSelector(repoType: type),
                ],
                footer: const _Footer(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child});

  final Widget child;

  static const _width = 420.0;
  static const _height = 580.0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Container(
        width: _width,
        height: _height,
        margin: const EdgeInsets.only(
          top: AppSpacing.xl2,
          bottom: AppSpacing.xl + PaneInfo.kHeight,
        ),
        padding: const EdgeInsets.only(
          top: AppSpacing.xl,
          left: AppSpacing.md,
          right: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: colors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withAlpha(40),
              blurRadius: 8,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final activePane = context.read<MultiPaneManagerCubit>().activePane().bloc;
    final canClose = activePane.state.openedBiblesIds.isNotEmpty;

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: AppSpacing.md),
            child: Text(
              'Select bibles',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
        IconButton(
          tooltip: 'Help',
          icon: const Icon(LucideIcons.helpCircle),
          // TODO: add help menu
          onPressed: () {},
        ),
        if (canClose)
          IconButton(
            tooltip: 'Close',
            icon: const Icon(LucideIcons.x),
            onPressed: () => activePane.add(BiblePaneChooseBibles()),
          ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final selectedIds = context.select(
      (BibleSelectorCubit c) => c.state.selectedBiblesIds,
    );
    final hasSelection = selectedIds.isNotEmpty;
    final limitReached = selectedIds.length > BiblePaneBloc.maxParallelBibles;

    return Column(
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              if (hasSelection) ...[
                Text(
                  '${selectedIds.length} selected',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                TextButton(
                  onPressed: () =>
                      context.read<BibleSelectorCubit>().setSelected(const []),
                  child: const Text('Clear'),
                ),
              ],
              const Spacer(),
              if (limitReached)
                Text(
                  'Max ${BiblePaneBloc.maxParallelBibles} bibles can be opened in parallel',
                  style: Theme.of(context).textTheme.bodySmall,
                )
              else
                ElevatedButton.icon(
                  autofocus: true,
                  iconAlignment: IconAlignment.end,
                  onPressed: hasSelection
                      ? () => context
                          .read<MultiPaneManagerCubit>()
                          .activePane()
                          .bloc
                          .add(BiblePaneOpen(bibleIds: selectedIds))
                      : null,
                  label: const Text('Confirm'),
                  icon: const Icon(LucideIcons.arrowRight),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
