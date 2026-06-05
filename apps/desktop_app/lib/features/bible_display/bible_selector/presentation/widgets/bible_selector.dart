import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/core/di/injection_container.dart' as di;
import 'package:open_scripture/features/bible_display/bible_selector/presentation/cubit/bible_selector_cubit.dart';
import 'package:open_scripture/features/bible_display/bible_selector/presentation/widgets/drift_selector.dart';
import 'package:open_scripture/features/bible_display/bible_selector/presentation/widgets/sword_selector.dart';
import 'package:open_scripture/features/customizer/presentation/models/bible_pane_general_theme.dart';
import 'package:open_scripture/features/customizer/presentation/state/customizer_cubit.dart';
import 'package:open_scripture/shared/domain/entities/bible_translation.dart';
import 'package:open_scripture/shared/enums/bible_repository_type.dart';
import 'package:open_scripture/shared/theme/tokens.dart';
import 'package:open_scripture/shared/widgets/ui/b_container_tab_bar.dart';

class BibleSelector extends StatefulWidget {
  final void Function(
      List<BibleId> selectedBibleIds, BibleRepositoryType repoType) onConfirm;
  final BibleSelectorCubit? bloc;

  const BibleSelector({required this.onConfirm, this.bloc, super.key});

  @override
  State<BibleSelector> createState() => _BibleSelectorState();
}

class _BibleSelectorState extends State<BibleSelector> {
  int _tabIndex = 0;

  static const _repoTypes = [
    BibleRepositoryType.intalled,
    BibleRepositoryType.sword,
    null, // TODO: implement the api list
  ];

  @override
  Widget build(BuildContext context) {
    final useCustom =
        context.select((CustomizerCubit b) => b.state.pane.enableCustomTheme);
    final paneTheme = Theme.of(context).extension<BiblePaneGeneralTheme>()!;

    return BlocProvider.value(
      value: widget.bloc ?? di.sl<BibleSelectorCubit>(),
      child: Center(
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
                      fontWeight: FontWeight.w900,
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
                  scrollableView: true,
                  viewBackgroundColor:
                      Theme.of(context).colorScheme.surfaceContainerHigh,
                  tabs: const ['Installed', 'Sword', 'Get Bible v2'],
                  onTabChanged: (i) => setState(() => _tabIndex = i),
                  views: [
                    DriftCatalogSelector(),
                    SwordSelector(),
                    const Placeholder(),
                  ],
                ),
              ),
              _FooterConfirmButton(
                tabIndex: _tabIndex,
                repoTypes: _repoTypes,
                onConfirm: widget.onConfirm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Reads selectedIds from the cubit and enables/disables based on
/// the active tab's repo type being available.
class _FooterConfirmButton extends StatelessWidget {
  const _FooterConfirmButton({
    required this.tabIndex,
    required this.repoTypes,
    required this.onConfirm,
  });

  final int tabIndex;
  final List<BibleRepositoryType?> repoTypes;
  final void Function(List<BibleId>, BibleRepositoryType) onConfirm;

  @override
  Widget build(BuildContext context) {
    final selectedIds =
        context.select((BibleSelectorCubit b) => b.state.selectedBiblesIds);

    final repoType = repoTypes[tabIndex];
    final canConfirm = selectedIds.isNotEmpty && repoType != null;

    return ElevatedButton(
      onPressed: canConfirm ? () => onConfirm(selectedIds, repoType) : null,
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
