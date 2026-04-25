import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:open_scripture/features/bible_installer_manager/presentation/state/installed_bibles/installed_bibles_bloc.dart';
// import 'package:open_scripture/features/settings_window/presentation/widgets/setting.dart';
// import 'package:open_scripture/features/settings_window/presentation/widgets/setting_input_text.dart';
// import 'package:open_scripture/features/settings_window/presentation/widgets/setting_section.dart';

class BibleMetaEditor extends StatelessWidget {
  const BibleMetaEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
    // return BlocBuilder<InstalledBiblesBloc, InstalledBiblesState>(
    //   builder: (context, state) {
    //     final meta = state.installedBibles
    //         .firstWhere((b) => b.extId == state.selectedBibleId);
    //     return Column(
    //       crossAxisAlignment: CrossAxisAlignment.end,
    //       spacing: 8,
    //       children: [
    //         Container(
    //           padding: const EdgeInsets.symmetric(vertical: 8),
    //           width: double.infinity,
    //           alignment: Alignment.center,
    //           decoration: BoxDecoration(
    //             color: Theme.of(context).colorScheme.surfaceContainerHighest,
    //             borderRadius: BorderRadius.circular(8),
    //           ),
    //           child: const Text(
    //             'Warning! This form editor is to fix or add missing metadata only',
    //             style: TextStyle(color: Colors.red),
    //           ),
    //         ),
    //         SettingSection(
    //           children: [
    //             if (meta.originSource == null)
    //               Setting(
    //                   label: 'Origin Source',
    //                   description: '',
    //                   child: SettingInputText()),
    //             Setting(
    //                 label: 'Abbreviation',
    //                 description: '',
    //                 child: SettingInputText(
    //                   value: meta.abbreviation,
    //                 )),
    //             Setting(
    //                 label: 'Language (eng)',
    //                 description: '',
    //                 child: SettingInputText(
    //                   value: meta.langEngName,
    //                 )),
    //             Setting(
    //                 label: 'Language (native)',
    //                 description: '',
    //                 child: SettingInputText(
    //                   value: meta.langNativeName,
    //                 )),
    //             Setting(
    //                 label: 'Language (iso 639)',
    //                 description: '',
    //                 child: SettingInputText(
    //                   value: meta.langIsoCode,
    //                 )),
    //           ],
    //         ),
    //         Expanded(child: SizedBox()),
    //         FilledButton(onPressed: () {}, child: const Text('Confirm')),
    //       ],
    //     );
    //   },
    // );
  }
}
