import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/core/di/injection_container.dart' as di;
import 'package:open_scripture/features/bible_display/bible_pane/presentation/state/bible_pane_bloc.dart';
import 'package:open_scripture/features/bible_display/bible_selector/presentation/cubit/bible_selector_cubit.dart';
import 'package:open_scripture/features/bible_display/bible_selector/presentation/widgets/drift_selector.dart';
import 'package:open_scripture/features/bible_display/bible_selector/presentation/widgets/sword_selector.dart';
import 'package:open_scripture/features/bible_display/multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import 'package:open_scripture/features/customizer/presentation/models/bible_pane_general_theme.dart';
import 'package:open_scripture/features/customizer/presentation/state/customizer_cubit.dart';
import 'package:open_scripture/shared/enums/bible_repository_type.dart';
import 'package:open_scripture/shared/theme/tokens.dart';
import 'package:open_scripture/shared/widgets/ui/b_container_tab_bar.dart';

class BibleSelector extends StatefulWidget {
  final BibleSelectorCubit? bloc;

  const BibleSelector({this.bloc, super.key});

  @override
  State<BibleSelector> createState() => _BibleSelectorState();
}

class _BibleSelectorState extends State<BibleSelector> {
  late final int _initialIndex;
  int _tabIndex = 0;

  static const _repoTypes = [
    BibleRepositoryType.installed,
    BibleRepositoryType.sword,
    null, // TODO: implement the api list
  ];
  @override
  void initState() {
    super.initState();

    final repoType = context.read<BiblePaneBloc>().state.repoType;
    print(repoType);
    final i = _repoTypes.indexOf(repoType);
    if (i < 0) return;
    _initialIndex = i;
  }

  @override
  Widget build(BuildContext context) {
    final useCustom =
        context.select((CustomizerCubit b) => b.state.pane.enableCustomTheme);
    final paneTheme = Theme.of(context).extension<BiblePaneGeneralTheme>()!;

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
                Column(
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
                ),
                //
                // Tabs & Views
                //
                Expanded(
                  child: BContainerTabBar(
                    initialIndex: _initialIndex,
                    scrollableView: true,
                    viewBackgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerHigh,
                    tabs: const ['Installed', 'Sword', 'Get Bible v2'],
                    onTabChanged: (i) {
                      if (_repoTypes[i] == null) return;
                      setState(() => _tabIndex = i);
                    },
                    views: const [
                      DriftCatalogSelector(),
                      SwordSelector(),
                      Placeholder(),
                    ],
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

    return ElevatedButton(
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
    );
  }
}
