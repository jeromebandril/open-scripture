import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_pane/presentation/widgets/parts/verse_widget.dart';
import 'package:the_smyrna_bible_v2/features/customizer/domain/entities/app_font_weight.dart';
import 'package:the_smyrna_bible_v2/features/customizer/domain/entities/app_theme.dart';
import 'package:the_smyrna_bible_v2/features/customizer/presentation/widgets/bible_pane_preview.dart';
import 'package:the_smyrna_bible_v2/features/settings_window/presentation/widgets/setting_input_bool.dart';
import 'package:the_smyrna_bible_v2/features/settings_window/presentation/widgets/setting.dart';
import 'package:the_smyrna_bible_v2/features/settings_window/presentation/widgets/setting_input_color.dart';
import 'package:the_smyrna_bible_v2/features/settings_window/presentation/widgets/setting_input_number.dart';
import 'package:the_smyrna_bible_v2/features/settings_window/presentation/widgets/setting_input_option.dart';
import 'package:the_smyrna_bible_v2/features/settings_window/presentation/widgets/setting_section.dart';
import 'package:the_smyrna_bible_v2/features/settings_window/presentation/widgets/setting_input_text.dart';

import '../cubit/customizer_cubit.dart';

const Map<HighlightRenderMode, String> highlitghtRenderModeString = {
  HighlightRenderMode.fullRefWithColor: 'Full ref with accent color'
};

const Map<ThemeMode, String> themeModeString = {
  ThemeMode.dark: 'Dark',
  ThemeMode.light: 'Light',
  ThemeMode.system: 'System',
};

const Map<SearchbarPosition, String> searchbarPosString = {
  SearchbarPosition.center: 'Center',
  SearchbarPosition.left: 'Left',
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
      padding: EdgeInsets.fromLTRB(42, 0, 42, 42),
      child: Column(
        children: [
          // TextButton(
          // onPressed: () => cubit.saveTheme(),
          // child: Text(
          //     'Save -- sorry you have to manually tap this button, still didn\'t implement async saving')),
          SettingSection(
            title: 'Global',
            children: [
              Setting(
                  label: 'Theme',
                  description: 'Set app theme',
                  child: SettingInputOption<ThemeMode>(
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
                  child: SettingInputColor(
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
                  child: SettingInputBool(
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
            title: 'Interface',
            children: [
              Setting(
                  label: 'Searchbar position',
                  description: 'Set searchbar\'s horizontal position',
                  child: SettingInputOption<SearchbarPosition>(
                    value: context.select(
                        (CustomizerCubit c) => c.state.app.searchbarPosition),
                    onChanged: (sp) {
                      cubit.updateTheme(
                          appTheme: (a) => a.copyWith(searchbarPosition: sp));
                    },
                    items: SearchbarPosition.values
                        .map((sp) => DropdownMenuItem<SearchbarPosition>(
                            value: sp,
                            child: Text(searchbarPosString[sp] ?? 'error')))
                        .toList(),
                  )),
              Setting(
                  label: 'Enable dynamic searchbar',
                  description: 'Show/Hide searchbar when needed',
                  child: SettingInputBool(
                    value: context.select((CustomizerCubit c) =>
                        c.state.app.enableDynamicSearchbar),
                    onChanged: (val) {
                      cubit.updateTheme(
                          appTheme: (a) =>
                              a.copyWith(enableDynamicSearchbar: val));
                    },
                  )),
            ],
          ),
          SettingSection(
            title: 'Bible viewer',
            rightSideChild: const BiblePanePreview(),
            children: [
              Setting(
                  label: 'Enable custom colors for Bible Viewer',
                  description:
                      'Enables custom color theming for the bible viewer',
                  child: SettingInputBool(
                    value: context.select(
                        (CustomizerCubit c) => c.state.pane.enableCustomTheme),
                    onChanged: (val) {
                      cubit.updateTheme(
                          paneTheme: (p) => p.copyWith(enableCustomTheme: val));
                    },
                  )),
              Setting(
                  label: 'Background color',
                  description: 'Set color for the background',
                  child: SettingInputColor(
                    isDisabled: !context.select(
                        (CustomizerCubit c) => c.state.pane.enableCustomTheme),
                    onColorChanged: (c) {
                      cubit.updateTheme(
                          paneTheme: (p) => p.copyWith(backgroundColor: c));
                    },
                    color: context.select(
                      (CustomizerCubit c) => c.state.pane.backgroundColor,
                    ),
                  )),
              Setting(
                  label: 'Reference color',
                  description: 'Set color for the verse reference (unselected)',
                  child: SettingInputColor(
                    isDisabled: !context.select(
                        (CustomizerCubit c) => c.state.pane.enableCustomTheme),
                    onColorChanged: (c) {
                      cubit.updateTheme(
                          paneTheme: (p) => p.copyWith(refColor: c));
                    },
                    color: context.select(
                      (CustomizerCubit c) => c.state.pane.refColor,
                    ),
                  )),
              Setting(
                  label: 'Text color',
                  description: 'Set color for the verse text',
                  child: SettingInputColor(
                    isDisabled: !context.select(
                        (CustomizerCubit c) => c.state.pane.enableCustomTheme),
                    onColorChanged: (c) {
                      cubit.updateTheme(
                          paneTheme: (p) => p.copyWith(textColor: c));
                    },
                    color: context.select(
                      (CustomizerCubit c) => c.state.pane.textColor,
                    ),
                  )),
              Setting(
                  label: 'Reference Font',
                  description: 'Set font for the reference text',
                  child: SettingInputText(
                    prefixIcon: Icons.text_fields_rounded,
                    onSubmitted: (font) {
                      cubit.updateTheme(
                          paneTheme: (p) => p.copyWith(referenceFont: font));
                    },
                    value: context.select(
                      (CustomizerCubit c) => c.state.pane.referenceFont,
                    ),
                  )),
              Setting(
                  label: 'Text Font',
                  description: 'Set font for the verse text',
                  child: SettingInputText(
                    prefixIcon: Icons.text_fields_rounded,
                    onSubmitted: (font) {
                      cubit.updateTheme(
                          paneTheme: (p) => p.copyWith(textFont: font));
                    },
                    value: context.select(
                      (CustomizerCubit c) => c.state.pane.textFont,
                    ),
                  )),
              Setting(
                  label: 'Text Font Weight',
                  description: 'Set font weight for verse text',
                  child: SettingInputOption<AppFontWeight>(
                    value: context.select(
                        (CustomizerCubit c) => c.state.pane.textFontWeight),
                    onChanged: (fw) {
                      cubit.updateTheme(
                          paneTheme: (p) => p.copyWith(textFontWeight: fw));
                    },
                    items: AppFontWeight.values
                        .map((fw) => DropdownMenuItem<AppFontWeight>(
                            value: fw, child: Text(fw.wire)))
                        .toList(),
                  )),
              Setting(
                  label: 'Show verse divider',
                  description: 'Show divider between verses',
                  child: SettingInputBool(
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
                  child: SettingInputBool(
                    value: context.select(
                      (CustomizerCubit c) => c.state.pane.showFullRefAlways,
                    ),
                    onChanged: (val) {
                      cubit.updateTheme(
                          paneTheme: (p) => p.copyWith(showFullRefAlways: val));
                    },
                  )),
              Setting(
                  label: 'Use hanging refs',
                  description: 'Enables hanging refs',
                  child: SettingInputBool(
                    value: context.select(
                        (CustomizerCubit c) => c.state.pane.enableHangingRefs),
                    onChanged: (val) {
                      cubit.updateTheme(
                          paneTheme: (p) => p.copyWith(enableHangingRefs: val));
                    },
                  )),
              Setting(
                  label: 'Selected verses render mode',
                  description: 'How selected verses are rendered',
                  child: SettingInputOption<HighlightRenderMode>(
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
                  )),
              Setting(
                  label: 'Horizontal padding',
                  description: 'Set horizontal padding',
                  child: SettingInputNumber(
                    suffixIcon: Icons.percent,
                    min: 0,
                    max: 100,
                    onSubmitted: (n) {
                      cubit.updateTheme(
                          paneTheme: (p) => p.copyWith(xPadding: n / 100));
                    },
                    value: context.select(
                      (CustomizerCubit c) =>
                          (c.state.pane.xPadding * 100).toString(),
                    ),
                  )),
            ],
          ),
          SettingSection(
            title: 'Splitscreenn prefs',
            children: [
              Setting(
                  label: 'Gap',
                  description: 'Set gap space between each bible pane view',
                  child: SettingInputNumber(
                    min: 0,
                    max: 100,
                    onSubmitted: (n) {
                      cubit.updateTheme(
                          paneTheme: (p) =>
                              p.copyWith(splitscreenGap: n.toInt()));
                    },
                    value: context.select(
                      (CustomizerCubit c) =>
                          c.state.pane.splitscreenGap.toString(),
                    ),
                  )),
            ],
          ),
          SettingSection(
            title: 'Advanced',
            children: [
              Setting(
                  label: 'Width adjustment',
                  description: 'Set horizontal padding to fit screen if needed',
                  child: SettingInputNumber(
                    min: 0,
                    max: 100,
                    onSubmitted: (n) {
                      cubit.updateTheme(
                          paneTheme: (p) =>
                              p.copyWith(widthAdjustmentOffset: n.toDouble()));
                    },
                    value: context.select(
                      (CustomizerCubit c) =>
                          c.state.pane.widthAdjustmentOffset.toString(),
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
