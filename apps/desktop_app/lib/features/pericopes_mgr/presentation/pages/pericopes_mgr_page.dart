import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart' as di;
import '../../../../shared/presentation/widgets/ui/inputs/file_dropzone.dart';
import '../../../settings_window/presentation/widgets/setting_section.dart';
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
                title: "Imported Pericopes",
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
    });
  }
}

class _InstalledPericopesList extends StatelessWidget {
  const _InstalledPericopesList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PericopesMgrCubit, PericopesMgrState>(
      buildWhen: (prev, curr) =>
          prev.installedPericopes != curr.installedPericopes ||
          prev.listStatus != curr.listStatus,
      builder: (context, state) {
        if (state.listStatus == PericopesMgrStatus.error) {
          return const Text('Error');
        }

        if (state.listStatus == PericopesMgrStatus.success) {
          return const Text('Loading');
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: state.installedPericopes.length,
          itemBuilder: (ctx, index) {
            final p = state.installedPericopes[index];
            return Card(child: Text(p.extId));
          },
        );
      },
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
