import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/extensions/build_context_extensions.dart';
import '../../../../../core/di/get_it_by_type.dart';
import '../../../../../core/di/injection_container.dart' as di;
import '../../../../../shared/design_system/design_system.dart';
import '../../../../../shared/domain/entities/bible_id.dart';
import '../../../../../shared/enums/bible_repository_type.dart';
import '../../../../../shared/presentation/widgets/async_singleton_builder.dart';
import '../../../../../shared/presentation/widgets/ui/inputs/app_input_text.dart';
import '../../../../my_library/presentation/state/my_library_cubit.dart';
import '../../../../settings_window/presentation/models/settings_route.dart';
import '../../../../settings_window/presentation/pages/settings_window.dart';
import '../cubit/bible_selector_cubit.dart';

extension on BibleRepositoryType {
  bool get showsFilter => this == BibleRepositoryType.cloudAPI;
  bool get supportsImport =>
      BibleRepositoryType.installableTypes.contains(this);

  String get emptyMessage => switch (this) {
        BibleRepositoryType.localDatabase => 'No installed bibles found',
        BibleRepositoryType.sword => 'No Sword modules installed',
        BibleRepositoryType.cloudAPI => 'No results found',
      };
}

class SharedCatalogSelector extends StatelessWidget {
  const SharedCatalogSelector({required this.repoType, super.key});

  final BibleRepositoryType repoType;

  @override
  Widget build(BuildContext context) {
    return AsyncSingletonBuilder<MyLibraryCubit>(
      resolver: () => di.sl.resolve<MyLibraryCubit>(repoType),
      loadingBuilder: (_) => const _LoadingView(),
      errorBuilder: (_, error, retry) => _ErrorView(
        message: '$error',
        onRetry: retry,
      ),
      builder: (_, cubit) => BlocProvider.value(
        value: cubit,
        child: _Catalog(repoType: repoType),
      ),
    );
  }
}

class _Catalog extends StatelessWidget {
  const _Catalog({required this.repoType});

  final BibleRepositoryType repoType;

  @override
  Widget build(BuildContext context) {
    final status = context.select((MyLibraryCubit c) => c.state.status);
    final errorMessage =
        context.select((MyLibraryCubit c) => c.state.errorMessage);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.md,
      children: [
        if (repoType.showsFilter) const _FilterInput(),
        Expanded(
          child: switch (status) {
            MyLibraryStatus.initial ||
            MyLibraryStatus.loading =>
              const _LoadingView(),
            MyLibraryStatus.error => _ErrorView(
                message: errorMessage ?? 'Error',
                onRetry: () => context.read<MyLibraryCubit>().getBibles(),
              ),
            MyLibraryStatus.success => _LibraryList(repoType: repoType),
          },
        ),
      ],
    );
  }
}

class _LibraryList extends StatelessWidget {
  const _LibraryList({required this.repoType});

  final BibleRepositoryType repoType;

  @override
  Widget build(BuildContext context) {
    final bibles = context.select(
      (MyLibraryCubit c) =>
          repoType.showsFilter ? c.state.filteredBibles : c.state.bibles,
    );
    final selectedIds = context.select(
      (BibleSelectorCubit c) => c.state.selectedBiblesIds,
    );

    if (bibles.isEmpty) {
      return _EmptyView(repoType: repoType);
    }

    return ListView.separated(
      itemCount: bibles.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
      itemBuilder: (context, index) {
        final bible = bibles[index];
        final id =
            BibleId(repoType: repoType, externalId: bible.extId.externalId);
        final position = selectedIds.indexOf(id);

        final (String title, String description, String? language) =
            switch (repoType) {
          BibleRepositoryType.sword => (bible.abbreviation, bible.name, null),
          _ => (
              bible.name,
              bible.description ?? bible.localName ?? bible.name,
              bible.langEngName ?? bible.langNativeName ?? bible.langIsoCode,
            ),
        };

        return _BibleTile(
          title: title,
          description: description,
          language: language,
          selectionOrder: position < 0 ? null : position + 1,
          onTap: () => context.read<BibleSelectorCubit>().select(id),
        );
      },
    );
  }
}

class _BibleTile extends StatelessWidget {
  const _BibleTile({
    required this.title,
    required this.description,
    required this.onTap,
    this.language,
    this.selectionOrder,
  });

  final String title;
  final String description;
  final String? language;
  final int? selectionOrder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final language = this.language;
    final selectionOrder = this.selectionOrder;

    return Card(
      child: ListTile(
        selected: selectionOrder != null,
        title: Text(title, style: theme.textTheme.bodyMedium),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description, style: theme.textTheme.bodySmall),
            if (language != null)
              Text(language, style: theme.textTheme.bodySmall),
          ],
        ),
        isThreeLine: language != null,
        trailing: selectionOrder == null
            ? null
            : Text(
                '$selectionOrder',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
        onTap: onTap,
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
  late final String _initialQuery;

  @override
  void initState() {
    super.initState();
    _initialQuery = context.read<MyLibraryCubit>().state.filterQuery;
  }

  @override
  Widget build(BuildContext context) {
    return AppInputText(
      value: _initialQuery,
      hint: 'Search by name or language',
      prefixIcon: Icons.search_rounded,
      debounce: const Duration(milliseconds: 250),
      onChanged: (query) => context.read<MyLibraryCubit>().filter(query),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.md,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.repoType});

  final BibleRepositoryType repoType;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            repoType.emptyMessage,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (repoType.supportsImport)
            TextButton.icon(
              onPressed: () => context.pushWindow(
                builder: (_) => SettingsWindow(
                  initialPage: SettingsPage.importer,
                ),
              ),
              icon: const Icon(Icons.file_upload_outlined),
              label: const Text('Go to Import Page'),
            ),
        ],
      ),
    );
  }
}
