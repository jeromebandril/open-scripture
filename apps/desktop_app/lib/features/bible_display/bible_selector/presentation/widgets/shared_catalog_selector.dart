import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/get_it_by_type.dart';
import '../../../../../core/di/injection_container.dart' as di;
import '../../../../../shared/design_system/design_system.dart';
import '../../../../../shared/enums/bible_repository_type.dart';
import '../../../../../shared/widgets/async_singleton_builder.dart';
import '../../../../../shared/widgets/ui/inputs/app_input_text.dart';
import '../../../../my_library/presentation/state/my_library_cubit.dart';
import '../../../../settings_window/presentation/models/settings_route.dart';
import '../../../../settings_window/presentation/pages/settings_window.dart';
import '../../../../window_stack_manager/presentation/state/window_stack_manager_bloc.dart';
import '../cubit/bible_selector_cubit.dart';

class SharedCatalogSelector extends StatelessWidget {
  final BibleRepositoryType repoType;
  final bool showFilter;
  final Widget? emptyWidget;
  final Function(BuildContext context)? onRetry;
  final String Function(dynamic bible)? titleBuilder;
  final Widget Function(BuildContext context, dynamic bible)? subtitleBuilder;

  const SharedCatalogSelector({
    super.key,
    required this.repoType,
    this.showFilter = false,
    this.emptyWidget,
    this.onRetry,
    this.titleBuilder,
    this.subtitleBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final selectedIds =
        context.select((BibleSelectorCubit b) => b.state.selectedBiblesIds);
    final theme = Theme.of(context);

    return AsyncSingletonBuilder<MyLibraryCubit>(
        resolver: () => di.sl.resolve<MyLibraryCubit>(repoType),
        loadingBuilder: (_) => const Center(child: CircularProgressIndicator()),
        errorBuilder: (_, error, retry) =>
            Text('error: $error'), // TODO: Replace with a proper error widget
        // _CatalogSelectorError(
        //       message: defaultErrorMessage,
        //       onRetry: () {
        //         retry();
        //         onRetry?.call();
        //       },
        //     ),
        builder: (context, cubit) {
          return BlocProvider.value(
            value: cubit,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: AppSpacing.md,
                children: [
                  if (showFilter) _FilterInput(),
                  //
                  // List
                  //
                  BlocBuilder<MyLibraryCubit, MyLibraryState>(
                    builder: (context, state) {
                      final bibles =
                          showFilter ? state.filteredBibles : state.bibles;

                      return switch (state.status) {
                        MyLibraryStatus.loading ||
                        MyLibraryStatus.initial =>
                          Center(child: CircularProgressIndicator()),
                        MyLibraryStatus.error => Expanded(
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 12,
                                children: [
                                  Text(state.errorMessage ?? 'Error',
                                      textAlign: TextAlign.center),
                                  if (onRetry != null)
                                    TextButton(
                                      onPressed: () => onRetry?.call(context),
                                      child: const Text('Retry'),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        MyLibraryStatus.ready => Expanded(
                            child: bibles.isEmpty
                                ? Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      emptyWidget ??
                                          const Text('No items found'),
                                      if (repoType !=
                                          BibleRepositoryType.cloudAPI)
                                        TextButton.icon(
                                            onPressed: () {
                                              context
                                                  .read<
                                                      WindowStackManagerBloc>()
                                                  .add(WindowStackManagerOpen
                                                      .selfManaged(
                                                          widget: SettingsWindow(
                                                              initialPage:
                                                                  SettingsPage
                                                                      .importer)));
                                            },
                                            icon: Icon(
                                                Icons.file_upload_outlined),
                                            label: Text('Go to Import Page'))
                                    ],
                                  )
                                : ListView.separated(
                                    itemCount: bibles.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: AppSpacing.xs),
                                    itemBuilder: (context, index) {
                                      final bible = bibles[index];
                                      final selected =
                                          selectedIds.contains(bible.extId);
                                      final hasLangInfo =
                                          bible.langEngName != null ||
                                              bible.langNativeName != null ||
                                              bible.langIsoCode != null;

                                      final String titleText =
                                          titleBuilder?.call(bible) ??
                                              bible.name;

                                      final defaultSubtitle = Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              bible.description ??
                                                  bible.localName ??
                                                  bible.name,
                                              style: theme.textTheme.bodySmall),
                                          if (hasLangInfo)
                                            Text(
                                                bible.langEngName ??
                                                    bible.langNativeName ??
                                                    bible.langIsoCode!,
                                                style:
                                                    theme.textTheme.bodySmall),
                                        ],
                                      );

                                      return Card(
                                        child: ListTile(
                                          selected: selected,
                                          title: Text(titleText),
                                          subtitle: subtitleBuilder?.call(
                                                  context, bible) ??
                                              defaultSubtitle,
                                          isThreeLine: hasLangInfo,
                                          trailing: selected
                                              ? Text(
                                                  '${selectedIds.indexOf(bible.extId) + 1}',
                                                  style: theme
                                                      .textTheme.titleLarge
                                                      ?.copyWith(
                                                    color: theme
                                                        .colorScheme.primary,
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
                          ),
                      };
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class _FilterInput extends StatefulWidget {
  const _FilterInput();

  @override
  State<_FilterInput> createState() => _FilterInputState();
}

class _FilterInputState extends State<_FilterInput> {
  late String _value;

  @override
  void initState() {
    super.initState();
    _value = context.read<MyLibraryCubit>().state.filterQuery;
  }

  @override
  Widget build(BuildContext context) {
    return AppInputText(
      value: _value,
      hint: 'Search by name or language',
      prefixIcon: Icons.search_rounded,
      onChanged: (v) => context.read<MyLibraryCubit>().filter(v),
    );
  }
}
