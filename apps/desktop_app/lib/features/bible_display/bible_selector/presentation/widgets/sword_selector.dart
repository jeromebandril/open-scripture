import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/core/di/injection_container.dart';
import 'package:open_scripture/features/bible_display/bible_selector/presentation/cubit/bible_selector_cubit.dart';
import 'package:open_scripture/features/my_library/presentation/cubit/my_library_cubit.dart';
import 'package:open_scripture/shared/theme/tokens.dart';

class SwordSelector extends StatelessWidget {
  const SwordSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl.get<MyLibraryCubit>(instanceName: 'local_sword'),
      child: _SwordSelectorBody(),
    );
  }
}

class _SwordSelectorBody extends StatelessWidget {
  const _SwordSelectorBody();

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
          //
          // List
          //
          BlocBuilder<MyLibraryCubit, MyLibraryState>(
            builder: (context, state) {
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
                      child: Text(
                          state.errorMessage ?? 'Failed to load Sword modules'),
                    ),
                  ),
                MyLibraryStatus.ready => state.bibles.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child:
                            Center(child: Text('No Sword modules installed')),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.bibles.length,
                        itemBuilder: (context, index) {
                          final bible = state.bibles[index];
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
                              title: Text(bible.name),
                              subtitle: Text(
                                bible.description ?? 'No description available',
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
