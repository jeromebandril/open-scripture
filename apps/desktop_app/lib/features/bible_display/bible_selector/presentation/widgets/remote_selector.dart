import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection_container.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../../../../../shared/enums/bible_repository_type.dart';
import '../../../../my_library/presentation/cubit/my_library_cubit.dart';
import '../cubit/bible_selector_cubit.dart';

class RemoteSelector extends StatelessWidget {
  const RemoteSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl.get<MyLibraryCubit>(
          instanceName: BibleRepositoryType.cloudAPI.name),
      child: _RemoteSelectorBody(),
    );
  }
}

class _RemoteSelectorBody extends StatelessWidget {
  const _RemoteSelectorBody();

  @override
  Widget build(BuildContext context) {
    // Reuse the same BibleSelectorCubit for selection tracking.
    final selectedIds =
        context.select((BibleSelectorCubit b) => b.state.selectedBiblesIds);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.md,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: const _FilterInput()),
          //
          // List
          //
          BlocBuilder<MyLibraryCubit, MyLibraryState>(
            builder: (context, state) {
              final bibles = state.filteredBibles;

              return switch (state.status) {
                MyLibraryStatus.loading ||
                MyLibraryStatus.initial =>
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                MyLibraryStatus.error => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(state.errorMessage ?? 'Uknown Error'),
                    ),
                  ),
                MyLibraryStatus.ready => bibles.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: Text('Found nothing')),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: bibles.length,
                        itemBuilder: (context, index) {
                          final bible = bibles[index];
                          final selected = selectedIds.contains(bible.extId);

                          return Card(
                            margin: const EdgeInsets.only(
                              bottom: AppSpacing.xs,
                              right: AppSpacing.xs,
                              left: AppSpacing.xs,
                            ),
                            clipBehavior: Clip.hardEdge,
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerLow,
                            child: ListTile(
                              hoverColor: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerLowest,
                              selected: selected,
                              title: Text(bible.abbreviation),
                              subtitle: Text(
                                bible.name,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                              trailing: selected
                                  ? Text(
                                      '${selectedIds.indexOf(bible.extId) + 1}',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 24,
                                      ),
                                    )
                                  : null,
                              onTap: () => context
                                  .read<BibleSelectorCubit>()
                                  .select(bible.extId),
                            ),
                          );
                        },
                      ),
              };
            },
          ),
        ],
      ),
    );
  }
}

class _FilterInput extends StatefulWidget {
  const _FilterInput();

  @override
  State<_FilterInput> createState() => _FilterInputState();
}

class _FilterInputState extends State<_FilterInput> {
  final _filterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filterController.text = context.read<MyLibraryCubit>().state.filterQuery;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _filterController,
      decoration: InputDecoration(hintText: 'Filter'),
      onChanged: (v) => context.read<MyLibraryCubit>().filter(v),
    );
  }
}
