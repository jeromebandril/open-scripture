import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/core/di/injection_container.dart' as di;
import 'package:open_scripture/features/bible_display/bible_selector/presentation/cubit/bible_selector_cubit.dart';
import 'package:open_scripture/features/bible_display/bible_selector/presentation/widgets/empty_catalog.dart';
import 'package:open_scripture/features/my_library/presentation/cubit/my_library_cubit.dart';
import 'package:open_scripture/shared/theme/tokens.dart';

class DriftCatalogSelector extends StatelessWidget {
  const DriftCatalogSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIds =
        context.select((BibleSelectorCubit b) => b.state.selectedBiblesIds);

    return BlocProvider.value(
      value: di.sl.get<MyLibraryCubit>(instanceName: 'local_drift'),
      child: Padding(
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
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 12,
                          children: [
                            Text(state.errorMessage ?? 'Failed to load bibles'),
                            ElevatedButton(
                              onPressed: () => print('Retry'),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  MyLibraryStatus.ready => state.bibles.isEmpty
                      ? const EmptyCatalog()
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.bibles.length,
                          itemBuilder: (context, index) {
                            final bible = state.bibles[index];
                            final selected = selectedIds.contains(bible.extId);
                            final hasLangInfo = bible.langEngName != null ||
                                bible.langNativeName != null ||
                                bible.langIsoCode != null;

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
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      bible.description ??
                                          bible.localName ??
                                          bible.name,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                    if (hasLangInfo)
                                      Text(
                                        bible.langEngName ??
                                            bible.langNativeName ??
                                            bible.langIsoCode!,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                      ),
                                  ],
                                ),
                                isThreeLine: hasLangInfo,
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
      ),
    );
  }
}
