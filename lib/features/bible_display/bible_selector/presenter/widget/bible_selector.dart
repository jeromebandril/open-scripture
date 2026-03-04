import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/bible_installer_manager/presentation/bloc/installed_bibles/installed_bibles_bloc.dart';
import 'package:open_scripture/features/customizer/presentation/cubit/customizer_cubit.dart';

import '../../../../../injection_container.dart';
import '../../../../customizer/presentation/models/bible_pane_general_theme.dart';
import '../bloc/bible_selector_bloc.dart';

class BibleSelector extends StatelessWidget {
  final void Function(List<int> selectedBibleId) onConfirm;
  final BibleSelectorBloc? bloc;

  const BibleSelector({required this.onConfirm, this.bloc, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc ?? sl<BibleSelectorBloc>()
        ..add(BibleSelectorInit()),
      child: _BibleSelectorBody(onConfirm: onConfirm),
    );
  }
}

class _BibleSelectorBody extends StatelessWidget {
  final void Function(List<int> selectedBibleId) onConfirm;

  const _BibleSelectorBody({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final selectedIds = context.select(
      (BibleSelectorBloc b) => b.state.selectedBibleIds,
    );

    final useCustom = context.select(
      (CustomizerCubit b) => b.state.pane.enableCustomTheme,
    );
    final paneTheme = Theme.of(context).extension<BiblePaneGeneralTheme>()!;
    final height = MediaQuery.sizeOf(context).height;

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(' Select a bible',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: useCustom
                          ? paneTheme.textColor
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
                SizedBox(height: 18),
                SizedBox(
                  height:
                      min(height * 0.5, state.installedBibles.length * 72.0),
                  child: ListView.separated(
                    itemCount: state.installedBibles.length,
                    separatorBuilder: (_, __) => const Divider(height: 0.05),
                    itemBuilder: (context, index) {
                      final bible = state.installedBibles[index];
                      final selected = selectedIds.contains(bible.id);
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
                SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: selectedIds.isEmpty
                          ? null
                          : () => onConfirm(selectedIds),
                      autofocus: true,
                      child: SizedBox(
                        width: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 4,
                          children: [
                            const Text('Confirm'),
                            const Icon(Icons.arrow_forward_rounded)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 42),
              ],
            );
            break;
        }
        return Center(
          child: SizedBox(width: 400, child: body),
        );
      },
    );
  }
}
