import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../../../shared/domain/entities/bible_translation.dart';
import '../../../../shared/widgets/hoverable_container.dart';
import '../../../settings_window/presentation/widgets/setting_section.dart';
import '../../settings/my_library_settings_cubit.dart';
import '../cubit/my_library_cubit.dart';

// TODO: implement a refresh button
// TODO: improve layout

extension _BibleTranslationFieldTable on BibleTranslation {
  Map<String, dynamic> toMap() => {
        'Local ID': localId,
        'External ID': extId,
        'Name': name,
        'Local Name': localName,
        'Abbreviation': abbreviation,
        'Language ISO Code': langIsoCode,
        'Language (English)': langEngName,
        'Language (Native)': langNativeName,
        'Origin Source': originSource,
        'Origin Format': originFormat,
        'Description': description,
        'Copyright': copyright,
      };
}

class LibraryManagerPage extends StatelessWidget {
  const LibraryManagerPage({
    super.key,
    this.onSelect,
    required this.title,
    this.subtitle,
    this.supportUninstallation = false,
  });

  final String title;
  final String? subtitle;
  final Function(BibleTranslation)? onSelect;
  final bool supportUninstallation;

  @override
  Widget build(BuildContext context) {
    final pref =
        context.select((MyLibrarySettingsCubit c) => c.state.preferredBibleId);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: BlocBuilder<MyLibraryCubit, MyLibraryState>(
            builder: (context, state) {
              return SettingListSection(
                title: title,
                subtitle: subtitle,
                isLoading: state.status == MyLibraryStatus.loading,
                isError: state.status == MyLibraryStatus.error,
                emptyListPlaceholder: Text('Empty'),
                errorPlaceholder: Text('Error'),
                filterInitValue:
                    context.read<MyLibraryCubit>().state.filterQuery,
                onFilter: (query) =>
                    context.read<MyLibraryCubit>().filter(query),
                itemCount: state.filteredBibles.length,
                separatorBuilder: (_, __) => Divider(height: 0.1),
                itemBuilder: (_, index) {
                  final bibles = state.filteredBibles;
                  final selIndex = state.selectedBibleIndex;
                  final isSelected = selIndex == null
                      ? false
                      : bibles[selIndex].extId == bibles[index].extId;
                  final isUninstalling =
                      state.uninstallingBibles.contains(bibles[index]);

                  return GestureDetector(
                    onTap: () => context.read<MyLibraryCubit>().select(index),
                    child: _InstalledBiblesRow(
                      isSelected: isSelected,
                      bibleMeta: bibles[index],
                      isUninstalling: isUninstalling,
                      supportUninstallation: supportUninstallation,
                      isPreference: pref == bibles[index].extId,
                    ),
                  );
                },
              );
            },
          ),
        ),
        BlocBuilder<MyLibraryCubit, MyLibraryState>(
          buildWhen: (prev, curr) =>
              prev.selectedBibleIndex != curr.selectedBibleIndex,
          builder: (context, state) {
            if (state.selectedBibleIndex == null) {
              return const SizedBox.shrink();
            }

            final bible = state.bibles[state.selectedBibleIndex!];
            final bibleInfos = bible.toMap();
            final isPreference = pref?.key == bible.extId.key;

            return SettingSection.single(
              title: 'Metadata of selected',
              actions: [
                TextButton(
                    onPressed: isPreference
                        ? () => context
                            .read<MyLibrarySettingsCubit>()
                            .updateSettings(
                                (s) => s.copyWith(preferredBibleId: () => null))
                        : () => context
                            .read<MyLibrarySettingsCubit>()
                            .updateSettings((s) => s.copyWith(
                                preferredBibleId: () => bible.extId)),
                    child: Row(
                      spacing: 4,
                      children: isPreference
                          ? const [
                              Icon(Icons.star_rounded),
                              Text('Remove preference'),
                            ]
                          : const [
                              Icon(Icons.star_outline_rounded),
                              Text('Set as preference'),
                            ],
                    ))
              ],
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 2,
                    children: [
                      for (final e in bibleInfos.entries)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 200, child: Text(e.key)),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                child: SelectableText(
                                    e.value != null ? e.value.toString() : ''),
                              ),
                            )
                          ],
                        )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}

class _InstalledBiblesRow extends StatelessWidget {
  final BibleTranslation bibleMeta;
  final bool isSelected;
  final bool isUninstalling;
  final bool supportUninstallation;
  final bool isPreference;

  const _InstalledBiblesRow({
    required this.bibleMeta,
    this.isSelected = false,
    this.isUninstalling = false,
    this.supportUninstallation = false,
    this.isPreference = false,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primaryContainer;

    return HoverableContainer(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        color: isSelected ? primaryColor : Colors.transparent,
      ),
      height: 38,
      hoveredColor: primaryColor,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          spacing: AppSpacing.lg,
          children: [
            SizedBox(
                width: 32,
                child: isPreference ? Icon(Icons.star_rounded) : null),
            Expanded(
              child: Text(
                bibleMeta.name.split("\\").last,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              child: Text(
                bibleMeta.langEngName ?? 'uknown',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (supportUninstallation)
              isUninstalling
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: LinearProgressIndicator(),
                    )
                  : TextButton(
                      onPressed: () =>
                          context.read<MyLibraryCubit>().uninstall(bibleMeta),
                      child: Row(
                        spacing: 8,
                        children: [
                          const Icon(Icons.delete_forever_outlined),
                          const Text('Uninstall'),
                        ],
                      ),
                    ),
          ],
        ),
      ),
    );
  }
}
