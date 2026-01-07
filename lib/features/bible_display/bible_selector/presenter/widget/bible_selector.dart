import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_smyrna_bible_v2/features/bible_installer_manager/presentation/bloc/installed_bibles/installed_bibles_bloc.dart';

import '../../../../../injection_container.dart';
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
            body = Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: state.installedBibles.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final bible = state.installedBibles[index];
                      final selected = bible.id == selectedId;

                      return ListTile(
                        selected: selected,
                        title: Text(bible.bibleName),
                        subtitle: Text(bible.abbreviation),
                        trailing: selected ? const Icon(Icons.check) : null,
                        onTap: () => context
                            .read<BibleSelectorBloc>()
                            .add(BibleSelectorSelect(bible.id!)),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
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
        return Container(
          width: 420,
          height: 520,
          padding: const EdgeInsets.all(16),
          child: body,
        );
      },
    );
  }
}
