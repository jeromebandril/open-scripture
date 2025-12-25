import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  const _BibleSelectorBody({required this.onConfirm, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BibleSelectorBloc, BibleSelectorState>(
      builder: (context, state) {
        Widget body;

        switch (state.status) {
          case BibleSelectorStatus.inital:
            body = const Center(child: CircularProgressIndicator());
            break;

          case BibleSelectorStatus.error:
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

          case BibleSelectorStatus.ready:
            body = Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: state.bibles.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final bible = state.bibles[index];
                      final selected = bible.id == state.selectedBibleId;

                      return ListTile(
                        selected: selected,
                        title: Text(bible.bibleName),
                        subtitle: Text(bible.abbreviation),
                        trailing: selected ? const Icon(Icons.check) : null,
                        onTap: () => context
                            .read<BibleSelectorBloc>()
                            .add(BibleSelectorSelect(bible.id)),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: state.selectedBibleId == null
                          ? null
                          : () => onConfirm(state.selectedBibleId!),
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
