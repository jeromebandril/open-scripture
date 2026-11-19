import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/extensions/build_context_extensions.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../shared/design_system/design_system.dart';
import '../../../../shared/presentation/widgets/ui/destructive_button.dart';
import '../../../../shared/presentation/widgets/ui/flex_data_table.dart';
import '../../../../shared/presentation/widgets/ui/inputs/file_dropzone.dart';
import '../../../settings_window/presentation/widgets/setting_section.dart';
import '../../domain/entities/pericope_set.dart';
import '../cubit/pericopes_mgr_cubit.dart';

class PericopesMgrPage extends StatelessWidget {
  const PericopesMgrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.sl<PericopesMgrCubit>(),
      child: Builder(builder: (context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(42, 0, 42, 42),
          child: Column(
            children: [
              SettingSection.single(
                title: 'Importer',
                child: const _ImporterWidget(),
              ),
              SettingSection.single(
                title: "My Pericopes",
                child: const _InstalledPericopesList(),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _ImporterWidget extends StatelessWidget {
  const _ImporterWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PericopesMgrCubit, PericopesMgrState>(
      buildWhen: (prev, curr) => prev.importStatus != curr.importStatus,
      builder: (_, state) {
        return FileDropZoneUi(
          errorText: state.errorMessage,
          isDragOver: false,
          isLoading: state.importStatus == PericopesMgrStatus.loading,
          onChoosePressed: () {
            context.read<PericopesMgrCubit>().pickFileToImport();
          },
          label: const Text("Import pericopes in json format"),
        );
      },
    );
  }
}

class _InstalledPericopesList extends StatefulWidget {
  const _InstalledPericopesList();

  @override
  State<_InstalledPericopesList> createState() =>
      _InstalledPericopesListState();
}

class _InstalledPericopesListState extends State<_InstalledPericopesList> {
  PericopeSet? selectedPericope;

  @override
  void initState() {
    super.initState();
    context.read<PericopesMgrCubit>().loadInstalledPericopes();
  }

  void _onSelectedRow(PericopeSet p) {
    setState(() => selectedPericope = selectedPericope == p ? null : p);
  }

  void _changePericopeAssignemnt(PericopeSet item) {
    context.pushStandardWindow(
      title: 'Select languages for ${item.extId}',
      maxSize: const Size(350, 500),
      builder: (_) => Placeholder(),
      // LanguagePicker(initialSelected: item.assignedTo, onSelected: (l) {}),
    );
    // context.read<PericopesMgrCubit>().assignPericope();
  }

  void _removePericope() {
    if (selectedPericope == null) return;
    context.read<PericopesMgrCubit>().removePericope(selectedPericope!.extId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.xl,
      children: [
        Text(
          'Pericopes are assigned to languages instead of bibles. '
          'Upon first import, a pericope is assigned to the detected language as default.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        BlocBuilder<PericopesMgrCubit, PericopesMgrState>(
          buildWhen: (prev, curr) =>
              prev.installedPericopes != curr.installedPericopes ||
              prev.listStatus != curr.listStatus,
          builder: (context, state) {
            if (state.listStatus == PericopesMgrStatus.error) {
              return const Text('Error');
            }

            if (state.listStatus == PericopesMgrStatus.loading) {
              return const Text('Loading');
            }

            return FlexDataTable<PericopeSet>(
              items: state.installedPericopes,
              shrinkWrap: true,
              onSelectItem: _onSelectedRow,
              selectedItem: selectedPericope,
              columns: [
                FlexTableColumn(
                  header: const Text('ID'),
                  flex: 1,
                  cellBuilder: (BuildContext context, PericopeSet item) =>
                      Text(item.extId),
                ),
                FlexTableColumn(
                  header: const Text('Name/Description'),
                  flex: 1,
                  cellBuilder: (BuildContext context, PericopeSet item) =>
                      Text(item.name ?? '<empty>'),
                ),
                FlexTableColumn(
                  header: const Text('Language'),
                  flex: 1,
                  cellBuilder: (BuildContext context, PericopeSet item) =>
                      Text(item.langIsoCode ?? '<uknown>'),
                ),
                FlexTableColumn(
                  header: const Text('Version'),
                  flex: 1,
                  cellBuilder: (BuildContext context, PericopeSet item) =>
                      Text(item.versionNumber.toString()),
                ),
                FlexTableColumn(
                  header: const Text('Assigned To'),
                  flex: 2,
                  cellBuilder: (BuildContext context, PericopeSet item) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.assignedTo.isEmpty
                                ? '<none>'
                                : item.assignedTo.join('\n'),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _changePericopeAssignemnt(item),
                          icon: const Icon(LucideIcons.pencil),
                        ),
                      ],
                    );
                  },
                ),
              ],
            );
          },
        ),
        if (selectedPericope != null)
          DestructiveButton(
            onPressed: _removePericope,
            variant: DestructiveButtonVariant.textWithIcon,
            icon: const Icon(LucideIcons.trash),
            child: Text('Remove ${selectedPericope!.extId}'),
          )
      ],
    );
  }
}

class _Description extends StatelessWidget {
  const _Description();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Text(
          'This is the Pericopes Manager Page. Here you can manage pericopes and detected languages. Coming soon.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
