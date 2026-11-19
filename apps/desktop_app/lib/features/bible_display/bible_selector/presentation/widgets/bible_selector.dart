import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/di/injection_container.dart' as di;
import '../../../../../shared/design_system/design_system.dart';
import '../../../../../shared/enums/bible_repository_type.dart';
import '../../../../../shared/presentation/widgets/dropdown_menu_anchor.dart';
import '../../../../../shared/presentation/widgets/ui/b_container_tab_bar.dart';
import '../../../../my_library/presentation/state/my_library_cubit.dart';
import '../../../bible_pane/presentation/state/bible_pane_bloc.dart';
import '../../../bible_pane/presentation/widgets/pane_info.dart';
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
      onRetry: (context) => context.read<MyLibraryCubit>().getBibles(),
    ),
    BibleRepositoryType.cloudAPI: SharedCatalogSelector(
      repoType: BibleRepositoryType.cloudAPI,
      showFilter: true,
      emptyWidget: const Text('No results found'),
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
            margin: const EdgeInsets.only(
              top: AppSpacing.xl2,
              bottom: AppSpacing.xl + PaneInfo.kHeight,
            ),
            padding: const EdgeInsets.only(
              top: AppSpacing.xl,
              right: AppSpacing.md,
              left: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            width: 420,
            height: 580,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //
                // Header
                //
                const _Header(),
                const SizedBox(height: AppSpacing.xl),
                //
                // Tabs & Views
                //
                Expanded(
                  child: BContainerTabBar(
                    initialIndex: _initialIndex,
                    tabs: _repoTypes.map((r) => r.label).toList(),
                    onTabChanged: (i) {
                      setState(() => _tabIndex = i);
                    },
                    views: enabledSelectorWidgets,
                    footer: _FooterConfirmButton(
                      tabIndex: _tabIndex,
                      repoTypes: _repoTypes,
                    ),
                  ),
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
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('  Select bibles', style: theme.textTheme.headlineSmall),
        const _HelpAboutBibleSelector(),
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

    return Column(
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              if (selectedIds.isNotEmpty) ...[
                Text(
                  '${selectedIds.length} selected',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                TextButton(
                  onPressed: () =>
                      context.read<BibleSelectorCubit>().setSelected([]),
                  child: const Text('Clear'),
                ),
              ],
              const Spacer(),
              ElevatedButton.icon(
                onPressed: canConfirm
                    ? () => context
                        .read<MultiPaneManagerCubit>()
                        .activePane()
                        .bloc
                        .add(BiblePaneOpen(bibleIds: selectedIds))
                    : null,
                autofocus: true,
                iconAlignment: IconAlignment.end,
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

class _HelpAboutBibleSelector extends StatefulWidget {
  const _HelpAboutBibleSelector();

  @override
  State<_HelpAboutBibleSelector> createState() =>
      _HelpAboutBibleSelectorState();
}

class _HelpAboutBibleSelectorState extends State<_HelpAboutBibleSelector> {
  late final ValueNotifier<bool> _menuVisible;
  bool isOpen = false;

  @override
  void initState() {
    super.initState();
    _menuVisible = ValueNotifier(isOpen);
  }

  @override
  Widget build(BuildContext context) {
    final h = 0.8;
    final menuContent = ListView(
      children: [
        Text(
          'You can choose between 3 sources of bibles: \n',
          style: TextStyle(height: h),
        ),
        Text(
          '-  <Canonical> are bibles installed locally\n',
          style: TextStyle(height: h),
        ),
        Text(
          '-  <Sword> are bibles installed locally for the sword engine by CrossWire\n',
          style: TextStyle(height: h),
        ),
        Text(
          '-  <GetBibleV2> are online bibles from a free API\n',
          style: TextStyle(height: h),
        )
      ],
    );

    return DropdownMenuAnchor(
      menuVisible: _menuVisible,
      menuContent: menuContent,
      menuHeight: 180,
      menuPadding: const EdgeInsets.all(AppSpacing.lg),
      trigger: IconButton(
        tooltip: 'Help',
        onPressed: () => setState(() {
          _menuVisible.value = !isOpen;
        }),
        icon: const Icon(LucideIcons.helpCircle),
      ),
    );
  }
}
