import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/my_library/presentation/cubit/my_library_cubit.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_section.dart';
import 'package:open_scripture/features/window_stack_manager/presentation/state/window_stack_manager_bloc.dart';
import 'package:open_scripture/shared/domain/entities/bible_translation.dart';
import 'package:open_scripture/shared/widgets/bible_meta_editor.dart';
import 'package:open_scripture/shared/widgets/hoverable_container.dart';

part '../widgets/library_bible_row.dart';

extension _BibleTranslationFieldTable on BibleTranslation {
  Map<String, dynamic> toTable() {
    return {'name': name, 'abbreviation': abbreviation};
  }
}

class LibraryManagerPage extends StatelessWidget {
  const LibraryManagerPage({super.key, this.onSelect});

  final Function(BibleTranslation)? onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<MyLibraryCubit, MyLibraryState>(
            builder: (context, state) {
              return SettingListSection(
                title: 'Installed',
                isLoading: state.status == MyLibraryStatus.loading,
                isError: state.status == MyLibraryStatus.error,
                emptyListPlaceholder: Text('No Installed bibles yet'),
                errorPlaceholder: Text('Error'),
                itemCount: state.bibles.length,
                separatorBuilder: (_, __) => Divider(height: 0.1),
                itemBuilder: (_, index) {
                  final bibles = state.bibles;
                  final selIndex = state.selectedBibleIndex;
                  final isSelected = selIndex == null
                      ? false
                      : bibles[selIndex].extId == bibles[index].extId;

                  return GestureDetector(
                    onTap: () => context.read<MyLibraryCubit>().select(index),
                    child: _InstalledBiblesRow(
                      isSelected: isSelected,
                      bibleMeta: bibles[index],
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

            final meta = state.bibles[state.selectedBibleIndex!].toTable();
            return SettingSection.single(
              title: 'Metadata of selected',
              actions: [
                TextButton(
                    onPressed: () {
                      context
                          .read<WindowStackManagerBloc>()
                          .add(WindowStackManagerOpen(
                            title: 'Edit Metadata',
                            widget: const BibleMetaEditor(),
                            size: Size(600, 565),
                          ));
                    },
                    child: const Row(
                      spacing: 4,
                      children: [
                        Icon(Icons.edit),
                        Text('Edit metadata'),
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
                      for (final e in meta.entries)
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
                                child: SelectableText(e.value),
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
