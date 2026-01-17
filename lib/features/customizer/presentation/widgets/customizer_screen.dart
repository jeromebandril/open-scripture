import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_pane/presentation/widgets/verse_widget.dart';
import 'package:the_smyrna_bible_v2/features/customizer/presentation/widgets/bible_pane_preview.dart';
import 'package:the_smyrna_bible_v2/features/settings_window/presentation/widgets/components/setting_bool_input.dart';
import 'package:the_smyrna_bible_v2/features/settings_window/presentation/widgets/components/setting.dart';
import 'package:the_smyrna_bible_v2/features/settings_window/presentation/widgets/components/setting_color_input.dart';
import 'package:the_smyrna_bible_v2/features/settings_window/presentation/widgets/components/setting_option_input.dart';
import 'package:the_smyrna_bible_v2/features/settings_window/presentation/widgets/components/setting_section.dart';
import 'package:the_smyrna_bible_v2/features/settings_window/presentation/widgets/components/setting_text_input.dart';

import '../cubit/customizer_cubit.dart';

const Map<HighlightRenderMode, String> highlitghtRenderModeString = {
  HighlightRenderMode.fullRefWithColor: 'Full ref with accent color'
};

const Map<ThemeMode, String> themeModeString = {
  ThemeMode.dark: 'Dark',
  ThemeMode.light: 'Light',
  ThemeMode.system: 'System',
};

class CustomizerScreen extends StatefulWidget {
  const CustomizerScreen({super.key});

  @override
  State<CustomizerScreen> createState() => _CustomizerScreenState();
}

class _CustomizerScreenState extends State<CustomizerScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CustomizerCubit>();

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(42, 0, 42, 0),
      child: Column(
        children: [
          TextButton(
              onPressed: () => cubit.saveTheme(cubit.state),
              child: Text(
                  'Save -- sorry you have to manually tap this button, still didn\'t implement async saving')),
          SettingSection(
            title: 'Global',
            children: [
              Setting(
                  label: 'Theme',
                  description: 'Set app theme',
                  child: SettingOptionInput<ThemeMode>(
                    value:
                        context.select((CustomizerCubit c) => c.state.app.mode),
                    onChanged: (mode) {
                      cubit.updateTheme(
                          appTheme: (a) => a.copyWith(mode: mode));
                    },
                    items: ThemeMode.values
                        .map((m) => DropdownMenuItem<ThemeMode>(
                            value: m,
                            child: Text(themeModeString[m] ?? 'error')))
                        .toList(),
                  )),
              Setting(
                  label: 'Accent color',
                  description: 'Set accent color for app',
                  child: SettingColorInput(
                    onColorChanged: (c) {
                      cubit.updateTheme(
                          appTheme: (a) => a.copyWith(accentColor: c));
                    },
                    color: context
                        .select((CustomizerCubit c) => c.state.app.accentColor),
                  )),
              Setting(
                  label: 'Enable auto colorscheme',
                  description:
                      'Use generated colorscheme based on accent color',
                  child: SettingBoolInput(
                    value: context.select((CustomizerCubit c) =>
                        c.state.app.enableAutoColorScheme),
                    onChanged: (val) {
                      cubit.updateTheme(
                          appTheme: (a) =>
                              a.copyWith(enableAutoColorScheme: val));
                    },
                  )),
              // Setting(
              //     label: 'Enable uniform background color',
              //     description:
              //         'use bible viewer\'s background color as app color',
              //     child: SettingBoolInput(
              //       value: context.select((CustomizerCubit c) =>
              //           c.state.theme.useBackgroundColorAsAppColor),
              //       onChanged: (val) {
              //         cubit.updateTheme((theme) =>
              //             theme.copyWith(useBackgroundColorAsAppColor: val));
              //       },
              //     )),
            ],
          ),
          SettingSection(
            title: 'Bible viewer',
            rightSideChild: const BiblePanePreview(),
            children: [
              Setting(
                  label: 'Enable custom theming for Bible Viewer',
                  description: 'Enables custom theming for the bible viewer',
                  child: SettingBoolInput(
                    value: context.select(
                        (CustomizerCubit c) => c.state.pane.enableCustomTheme),
                    onChanged: (val) {
                      cubit.updateTheme(
                          paneTheme: (p) => p.copyWith(enableCustomTheme: val));
                    },
                  )),
              Setting(
                  label: 'Font text',
                  description: 'Set font for the verse text',
                  child: SettingTextInput(
                    value: context.select(
                      (CustomizerCubit c) => c.state.app.fontFamily,
                    ),
                  )),
              Setting(
                  label: 'Text color',
                  description: 'Set color for the verse text',
                  child: SettingColorInput(
                    onColorChanged: (c) {
                      cubit.updateTheme(
                          paneTheme: (p) => p.copyWith(textColor: c));
                    },
                    color: context.select(
                      (CustomizerCubit c) => c.state.pane.textColor,
                    ),
                  )),
              Setting(
                  label: 'Background color',
                  description: 'Set color for the background',
                  child: SettingColorInput(
                    onColorChanged: (c) {
                      cubit.updateTheme(
                          paneTheme: (p) => p.copyWith(backgroundColor: c));
                    },
                    color: context.select(
                      (CustomizerCubit c) => c.state.pane.backgroundColor,
                    ),
                  )),
              Setting(
                  label: 'Show verse divider',
                  description: 'Show divider between verses',
                  child: SettingBoolInput(
                    value: context.select(
                      (CustomizerCubit c) => c.state.pane.showVerseDivider,
                    ),
                    onChanged: (val) {
                      cubit.updateTheme(
                          paneTheme: (p) => p.copyWith(showVerseDivider: val));
                    },
                  )),
              Setting(
                  label: 'Show full ref',
                  description: 'Show full verse reference or only verse number',
                  child: SettingBoolInput(
                    value: context.select(
                      (CustomizerCubit c) => c.state.pane.showFullRefAlways,
                    ),
                    onChanged: (val) {
                      cubit.updateTheme(
                          paneTheme: (p) => p.copyWith(showFullRefAlways: val));
                    },
                  )),
              Setting(
                  label: 'Selected verses render mode',
                  description: 'How selected verses are rendered',
                  child: SettingOptionInput<HighlightRenderMode>(
                    value: context.select((CustomizerCubit c) =>
                        c.state.pane.highlightRenderMode),
                    onChanged: (mode) {
                      cubit.updateTheme(
                          paneTheme: (p) =>
                              p.copyWith(highlightRenderMode: mode));
                    },
                    items: HighlightRenderMode.values
                        .map((m) => DropdownMenuItem<HighlightRenderMode>(
                            value: m,
                            child: Text(
                              highlitghtRenderModeString[m] ?? 'error',
                            )))
                        .toList(),
                  ))
            ],
          ),
          SizedBox(height: 42)
        ],
      ),
    );
  }
}
