import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection_container.dart' as di;
import '../../../../../shared/design_system/design_system.dart';
import '../../../../../shared/enums/bible_repository_type.dart';
import '../../../../../shared/widgets/ui/b_container_tab_bar.dart';
import '../../../../customizer/presentation/models/bible_pane_general_theme.dart';
import '../../../../customizer/presentation/state/customizer_cubit.dart';
import '../../../../my_library/presentation/cubit/my_library_cubit.dart';
import '../../../bible_pane/presentation/state/bible_pane_bloc.dart';
import '../../../multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import '../cubit/bible_selector_cubit.dart';
import 'shared_catalog_selector.dart';

class BibleSelector extends StatefulWidget {
  final BibleSelectorCubit? bloc;

  const BibleSelector({this.bloc, super.key});

  @override
  State<BibleSelector> createState() => _BibleSelectorState();
}

class _BibleSelectorState extends State<BibleSelector> {
  late final int _initialIndex;
  int _tabIndex = 0;

  static const _repoTypes = BibleRepositoryType.platformEnabled;

  final allSelectorWidgets = {
    BibleRepositoryType.localDatabase: SharedCatalogSelector(
      repoType: BibleRepositoryType.localDatabase,
      emptyWidget: const Text('No installed bibles found'),
      // TODO: call reload logic here (which is not implemented yet)
      onRetry: (context) => context.read<MyLibraryCubit>().getBibles(),
    ),
    BibleRepositoryType.sword: SharedCatalogSelector(
      repoType: BibleRepositoryType.sword,
      emptyWidget: const Text('No Sword modules installed'),
      titleBuilder: (bible) => bible.abbreviation,
      subtitleBuilder: (context, bible) => Text(
        bible.name,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      defaultErrorMessage: 'Failed to load Sword modules',
      onRetry: (context) => context.read<MyLibraryCubit>().getBibles(),
    ),
    BibleRepositoryType.cloudAPI: SharedCatalogSelector(
      repoType: BibleRepositoryType.cloudAPI,
      showFilter: true, // Enables the search bar
      emptyWidget: const Text('Found nothing'),
      defaultErrorMessage: 'Unknown Error',
      onRetry: (context) => context.read<MyLibraryCubit>().getBibles(),
    ),
  };
  List<Widget> get enabledSelectorWidgets {
    return _repoTypes
        .map((type) => allSelectorWidgets[type])
        .whereType<Widget>()
        .toList();
  }

  @override
  void initState() {
    super.initState();

    final repoType = context.read<BiblePaneBloc>().state.repoType;
    final i = _repoTypes.indexOf(repoType);
    // defaults to zero
    _initialIndex = i < 0 ? 0 : i;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          widget.bloc ??
          di.sl<BibleSelectorCubit>(
            param1: context.read<BiblePaneBloc>().state.openedBiblesIds,
            param2: context.read<BiblePaneBloc>().state.repoType,
          ),
      child: Builder(builder: (context) {
        return Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            width: 400,
            height: 580,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.md,
              children: [
                //
                // Header
                //
                const _Header(),
                //
                // Tabs & Views
                //
                Expanded(
                  child: BContainerTabBar(
                    initialIndex: _initialIndex,
                    scrollableView: true,
                    viewBackgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerHigh,
                    tabs: _repoTypes.map((r) => r.label).toList(),
                    onTabChanged: (i) {
                      setState(() => _tabIndex = i);
                    },
                    views: enabledSelectorWidgets,
                  ),
                ),
                _FooterConfirmButton(
                  tabIndex: _tabIndex,
                  repoTypes: _repoTypes,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final useCustom =
        context.select((CustomizerCubit b) => b.state.pane.enableCustomTheme);
    final paneTheme = Theme.of(context).extension<BiblePaneGeneralTheme>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.xs,
      children: [
        Text(
          'Select bibles',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: useCustom
                ? paneTheme.textColor
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          'Choose one source and multiple bibles for parallel view',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Reads selectedIds from the cubit and enables/disables based on
/// the active tab's repo type being available.
class _FooterConfirmButton extends StatelessWidget {
  const _FooterConfirmButton({
    required this.tabIndex,
    required this.repoTypes,
  });

  final int tabIndex;
  final List<BibleRepositoryType?> repoTypes;

  @override
  Widget build(BuildContext context) {
    final selectedIds =
        context.select((BibleSelectorCubit b) => b.state.selectedBiblesIds);

    final repoType = repoTypes[tabIndex];
    final canConfirm = selectedIds.isNotEmpty && repoType != null;

    return Row(
      children: [
        if (selectedIds.isNotEmpty)
          TextButton(
              onPressed: () =>
                  context.read<BibleSelectorCubit>().setSelected([]),
              child: Text('Unselect All (${selectedIds.length})')),
        const Spacer(),
        ElevatedButton(
          onPressed: canConfirm
              ? () => context
                  .read<MultiPaneManagerCubit>()
                  .activePane()
                  .bloc
                  .add(BiblePaneOpen(bibleIds: selectedIds))
              : null,
          autofocus: true,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 4,
            children: [
              Text('Confirm'),
              Icon(Icons.arrow_forward_rounded),
            ],
          ),
        ),
      ],
    );
  }
}
