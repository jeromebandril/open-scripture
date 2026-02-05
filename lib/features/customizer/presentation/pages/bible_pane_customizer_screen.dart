import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_smyrna_bible_v2/features/customizer/domain/entities/app_font_weight.dart';
import 'package:the_smyrna_bible_v2/features/customizer/domain/entities/bible_pane_general_theme_settings.dart';
import 'package:the_smyrna_bible_v2/features/customizer/presentation/widgets/bible_pane_preview.dart';
import 'package:the_smyrna_bible_v2/features/settings_window/presentation/widgets/setting_input_bool.dart';
import 'package:the_smyrna_bible_v2/features/settings_window/presentation/widgets/setting.dart';
import 'package:the_smyrna_bible_v2/features/settings_window/presentation/widgets/setting_input_color.dart';
import 'package:the_smyrna_bible_v2/features/settings_window/presentation/widgets/setting_input_number.dart';
import 'package:the_smyrna_bible_v2/features/settings_window/presentation/widgets/setting_input_option.dart';
import 'package:the_smyrna_bible_v2/features/settings_window/presentation/widgets/setting_section.dart';
import 'package:the_smyrna_bible_v2/features/settings_window/presentation/widgets/setting_input_text.dart';

import '../../domain/entities/highlight_render_mode.dart';
import '../../domain/entities/searchbar_position.dart';
import '../cubit/customizer_cubit.dart';

const Map<ThemeMode, String> themeModeString = {
  ThemeMode.dark: 'Dark',
  ThemeMode.light: 'Light',
  ThemeMode.system: 'System',
};

const Map<SearchbarPosition, String> searchbarPosString = {
  SearchbarPosition.center: 'Center',
  SearchbarPosition.left: 'Left',
};

class BiblePaneCustomizerScreen extends StatefulWidget {
  const BiblePaneCustomizerScreen({super.key});

  @override
  State<BiblePaneCustomizerScreen> createState() =>
      _BiblePaneCustomizerScreenState();
}

class _BiblePaneCustomizerScreenState extends State<BiblePaneCustomizerScreen> {
  final defaultPaneTheme = BiblePaneGeneralThemeSettings();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CustomizerCubit>();

    return Padding(
      padding: EdgeInsets.fromLTRB(42, 0, 42, 42),
      child: Row(
        spacing: 16,
        children: [
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(0, 0, 24, 0),
              child: Column(
                children: [
                  SettingSection(
                    title: 'Bible viewer theme',
                    children: [
                      Setting(
                          label: 'Enable custom colors',
                          description:
                              'Enables custom color theming or use app\'s theme',
                          child: SettingInputBool(
                            value: context.select((CustomizerCubit c) =>
                                c.state.pane.enableCustomTheme),
                            onChanged: (val) {
                              cubit.updateTheme(
                                  paneTheme: (p) =>
                                      p.copyWith(enableCustomTheme: val));
                            },
                          )),
                      Setting(
                          label: 'Background color',
                          description: 'Set color for the background',
                          child: SettingInputColor(
                            showReset: defaultPaneTheme.backgroundColor !=
                                context.select((CustomizerCubit c) =>
                                    c.state.pane.backgroundColor),
                            onReset: () {
                              cubit.updateTheme(
                                  paneTheme: (a) => a.copyWith(
                                      backgroundColor:
                                          defaultPaneTheme.backgroundColor));
                            },
                            isDisabled: !context.select((CustomizerCubit c) =>
                                c.state.pane.enableCustomTheme),
                            onColorChanged: (c) {
                              cubit.updateTheme(
                                  paneTheme: (p) =>
                                      p.copyWith(backgroundColor: c));
                            },
                            color: context.select(
                              (CustomizerCubit c) =>
                                  c.state.pane.backgroundColor,
                            ),
                          )),
                      Setting(
                          label: 'Reference color',
                          description:
                              'Set color for the verse reference (unselected)',
                          child: SettingInputColor(
                            showReset: defaultPaneTheme.refColor !=
                                context.select((CustomizerCubit c) =>
                                    c.state.pane.refColor),
                            onReset: () {
                              cubit.updateTheme(
                                  paneTheme: (a) => a.copyWith(
                                      refColor: defaultPaneTheme.refColor));
                            },
                            isDisabled: !context.select((CustomizerCubit c) =>
                                c.state.pane.enableCustomTheme),
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
                            showReset: defaultPaneTheme.textColor !=
                                context.select((CustomizerCubit c) =>
                                    c.state.pane.textColor),
                            onReset: () {
                              cubit.updateTheme(
                                  paneTheme: (a) => a.copyWith(
                                      textColor: defaultPaneTheme.textColor));
                            },
                            isDisabled: !context.select((CustomizerCubit c) =>
                                c.state.pane.enableCustomTheme),
                            onColorChanged: (c) {
                              cubit.updateTheme(
                                  paneTheme: (p) => p.copyWith(textColor: c));
                            },
                            color: context.select(
                              (CustomizerCubit c) => c.state.pane.textColor,
                            ),
                          )),
                      Setting(
                          label: 'Show verse divider',
                          description: 'Show divider between verses',
                          child: SettingInputBool(
                            value: context.select(
                              (CustomizerCubit c) =>
                                  c.state.pane.showVerseDivider,
                            ),
                            onChanged: (val) {
                              cubit.updateTheme(
                                  paneTheme: (p) =>
                                      p.copyWith(showVerseDivider: val));
                            },
                          )),
                      Setting(
                          label: 'Show full ref',
                          description:
                              'Show full verse reference or only verse number',
                          child: SettingInputBool(
                            value: context.select(
                              (CustomizerCubit c) =>
                                  c.state.pane.showFullRefAlways,
                            ),
                            onChanged: (val) {
                              cubit.updateTheme(
                                  paneTheme: (p) =>
                                      p.copyWith(showFullRefAlways: val));
                            },
                          )),
                      Setting(
                          label: 'Use hanging refs',
                          description: 'Enables hanging refs',
                          child: SettingInputBool(
                            value: context.select((CustomizerCubit c) =>
                                c.state.pane.enableHangingRefs),
                            onChanged: (val) {
                              cubit.updateTheme(
                                  paneTheme: (p) =>
                                      p.copyWith(enableHangingRefs: val));
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
                                .map((m) =>
                                    DropdownMenuItem<HighlightRenderMode>(
                                        value: m, child: Text(m.wire)))
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
                                  paneTheme: (p) =>
                                      p.copyWith(xPadding: n / 100));
                            },
                            value: context.select(
                              (CustomizerCubit c) =>
                                  (c.state.pane.xPadding * 100).toString(),
                            ),
                          )),
                    ],
                  ),
                  SettingSection(
                    title: 'Typography',
                    children: [
                      Setting(
                          label: 'Reference Font',
                          description: 'Set font for the reference text',
                          child: SettingInputText(
                            prefixIcon: Icons.text_fields_rounded,
                            onSubmitted: (font) {
                              cubit.updateTheme(
                                  paneTheme: (p) =>
                                      p.copyWith(referenceFont: font));
                            },
                            value: context.select(
                              (CustomizerCubit c) => c.state.pane.referenceFont,
                            ),
                          )),
                      Setting(
                          label: 'Reference Font Weight',
                          description:
                              'Set font weight for unselected references',
                          child: SettingInputOption<AppFontWeight>(
                            value: context.select((CustomizerCubit c) =>
                                c.state.pane.refFontWeight),
                            onChanged: (fw) {
                              cubit.updateTheme(
                                  paneTheme: (p) =>
                                      p.copyWith(refFontWeight: fw));
                            },
                            items: AppFontWeight.values
                                .map((fw) => DropdownMenuItem<AppFontWeight>(
                                    value: fw, child: Text(fw.wire)))
                                .toList(),
                          )),
                      Setting(
                          label: 'Selected reference Font Weight',
                          description:
                              'Set font weight for selected references',
                          child: SettingInputOption<AppFontWeight>(
                            value: context.select((CustomizerCubit c) =>
                                c.state.pane.selectedRefFontWeight),
                            onChanged: (fw) {
                              cubit.updateTheme(
                                  paneTheme: (p) =>
                                      p.copyWith(selectedRefFontWeight: fw));
                            },
                            items: AppFontWeight.values
                                .map((fw) => DropdownMenuItem<AppFontWeight>(
                                    value: fw, child: Text(fw.wire)))
                                .toList(),
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
                            value: context.select((CustomizerCubit c) =>
                                c.state.pane.textFontWeight),
                            onChanged: (fw) {
                              cubit.updateTheme(
                                  paneTheme: (p) =>
                                      p.copyWith(textFontWeight: fw));
                            },
                            items: AppFontWeight.values
                                .map((fw) => DropdownMenuItem<AppFontWeight>(
                                    value: fw, child: Text(fw.wire)))
                                .toList(),
                          )),
                    ],
                  ),
                  SettingSection(
                    title: 'Specific Render',
                    children: [
                      Setting(
                          label: 'Quote color',
                          description: 'Set color for the verse text',
                          child: SettingInputColor(
                            showReset: defaultPaneTheme.quoteColor !=
                                context.select((CustomizerCubit c) =>
                                    c.state.pane.quoteColor),
                            onReset: () {
                              cubit.updateTheme(
                                  paneTheme: (a) => a.copyWith(
                                      quoteColor: defaultPaneTheme.quoteColor));
                            },
                            isDisabled: !context.select((CustomizerCubit c) =>
                                c.state.pane.enableCustomTheme),
                            onColorChanged: (c) {
                              cubit.updateTheme(
                                  paneTheme: (p) => p.copyWith(quoteColor: c));
                            },
                            color: context.select(
                              (CustomizerCubit c) => c.state.pane.quoteColor,
                            ),
                          )),
                    ],
                  ),
                  SettingSection(
                    title: 'Splitscreenn prefs',
                    children: [
                      Setting(
                          label: 'Gap',
                          description:
                              'Set gap space between each bible pane view',
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
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: SettingSection(
              title: 'Preview',
              children: [
                Center(child: const BiblePanePreview()),
              ],
            ),
          )
        ],
      ),
    );
  }
}
