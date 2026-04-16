import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_section.dart';
import 'package:open_scripture/features/window_stack_manager/presentation/bloc/window_stack_manager_bloc.dart';
import 'package:open_scripture/shared/presentation/widgets/bible_meta_editor.dart';

import '../../../../shared/domain/entities/bible_meta.dart';
import '../../../../shared/presentation/widgets/hoverable_container.dart';
import '../bloc/installed_bibles/installed_bibles_bloc.dart';

part 'installed_bibles_row.dart';

class InstalledBiblesSection extends StatelessWidget {
  const InstalledBiblesSection({super.key, this.onSelect});

  final Function(BibleMeta)? onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<InstalledBiblesBloc, InstalledBiblesState>(
            builder: (context, state) {
              return SettingListSection(
                title: 'Installed',
                isLoading: state.status == InstalledBiblesStatus.loading,
                isError: state.status == InstalledBiblesStatus.error,
                emptyListPlaceholder: Text('No Installed bibles yet'),
                errorPlaceholder: Text('Error'),
                itemCount: state.installedBibles.length,
                separatorBuilder: (_, __) => Divider(height: 0.1),
                itemBuilder: (_, index) {
                  final selected = state.selectedBibleId ==
                      state.installedBibles[index].extId;
                  return GestureDetector(
                    onTap: () {
                      final toSelect =
                          selected ? null : state.installedBibles[index].extId;
                      context
                          .read<InstalledBiblesBloc>()
                          .add(InstalledBiblesSelect(selectedId: toSelect));
                    },
                    child: _InstalledBiblesRow(
                      selected: selected,
                      bibleMeta: state.installedBibles[index],
                    ),
                  );
                },
              );
            },
          ),
        ),
        BlocBuilder<InstalledBiblesBloc, InstalledBiblesState>(
          buildWhen: (prev, curr) =>
              prev.selectedBibleId != curr.selectedBibleId,
          builder: (context, state) {
            final sel = state.selectedBibleId;
            if (sel == null) return const SizedBox.shrink();
            final meta =
                state.installedBibles.firstWhere((b) => b.extId == sel).toMap();
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
