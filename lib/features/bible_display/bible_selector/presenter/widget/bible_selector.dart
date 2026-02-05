import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/bible_installer_manager/presentation/bloc/installed_bibles/installed_bibles_bloc.dart';
import 'package:open_scripture/features/customizer/presentation/cubit/customizer_cubit.dart';

import '../../../../../injection_container.dart';
import '../../../../customizer/presentation/models/bible_pane_general_theme.dart';
import '../bloc/bloc/bible_selector_bloc.dart';

class BibleSelector extends StatelessWidget {
  final void Function(int selectedBibleId) onConfirm;

  const BibleSelector({required this.onConfirm, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = sl<BibleSelectorBloc>(); // or BibleListBloc(repo: sl())
        bloc.add(BibleSelectorInit());
        return bloc;
      },
      child: _BibleSelectorBody(onConfirm: onConfirm),
    );
  }
}

class _BibleSelectorBody extends StatelessWidget {
  final void Function(int selectedBibleId) onConfirm;

  const _BibleSelectorBody({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final selectedId = context.select(
      (BibleSelectorBloc b) => b.state.selectedBibleId,
    );
    final useCustom = context.select(
      (CustomizerCubit b) => b.state.pane.enableCustomTheme,
    );
    final paneTheme = Theme.of(context).extension<BiblePaneGeneralTheme>()!;

    return BlocBuilder<InstalledBiblesBloc, InstalledBiblesState>(
      builder: (context, state) {
        Widget body;
        switch (state.status) {
          case InstalledBiblesStatus.loading || InstalledBiblesStatus.initial:
            body = const Center(child: CircularProgressIndicator());
            break;

          case InstalledBiblesStatus.error:
            body = Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.errorMessage ?? 'Failed to load bibles'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => print(
                        'retry'), //context.read<BibleSelectorBloc>().add(const BibleSelectorRetry()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
            break;

          case InstalledBiblesStatus.loaded:
            if (state.installedBibles.isEmpty) {
              body = Text('Go to <Bible> to install a bible',
                  textAlign: TextAlign.center);
              break;
            }
            body = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 12,
              children: [
                SizedBox(
                  height: state.installedBibles.length * 85,
                  child: ListView.separated(
                    itemCount: state.installedBibles.length,
                    separatorBuilder: (_, __) => const Divider(height: 0.1),
                    itemBuilder: (context, index) {
                      final bible = state.installedBibles[index];
                      final selected = bible.id == selectedId;
                      final style = TextStyle(
                        color: useCustom
                            ? paneTheme.textColor
                            : Theme.of(context).colorScheme.onSurface,
                      );

                      return ListTile(
                        selected: selected,
                        title: Text(bible.bibleNameLocal, style: style),
                        subtitle: Text(
                          bible.abbreviation,
                          style: style,
                        ),
                        trailing: selected ? const Icon(Icons.check) : null,
                        onTap: () => context.read<BibleSelectorBloc>().add(
                              BibleSelectorSelect(bible.id!),
                            ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: selectedId == null
                          ? null
                          : () => onConfirm(selectedId),
                      child: const Text('Confirm'),
                    ),
                  ],
                ),
              ],
            );
            break;
        }
        return Center(
          child: SizedBox(
            width: 400,
            child: body,
          ),
        );
      },
    );
  }
}
