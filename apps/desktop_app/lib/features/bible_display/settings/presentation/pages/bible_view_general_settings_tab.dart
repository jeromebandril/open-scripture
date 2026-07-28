import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/settings/app_settings.dart';
import '../../../../../app/widgets/font_picker.dart';
import '../../../../../core/settings/settings_cubit.dart';
import '../../../../../shared/fonts/app_font.dart';
import '../../../../../shared/widgets/ui/inputs/app_input_bool.dart';
import '../../../../../shared/widgets/ui/inputs/app_input_color.dart';
import '../../../../../shared/widgets/ui/inputs/app_input_number.dart';
import '../../../../../shared/widgets/ui/inputs/app_input_option.dart';
import '../../../../settings_window/presentation/widgets/setting.dart';
import '../../../../settings_window/presentation/widgets/setting_section.dart';
import '../../bible_view_settings.dart';
import '../../domain/entities/bible_view_font_weight.dart';

class BibleViewGeneralSettingsTab extends StatefulWidget {
  const BibleViewGeneralSettingsTab({super.key, this.showPreview = false});

  final bool showPreview;

  @override
  State<BibleViewGeneralSettingsTab> createState() =>
      _BibleViewGeneralSettingsTabState();
}

class _BibleViewGeneralSettingsTabState
    extends State<BibleViewGeneralSettingsTab> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit<BibleViewSettings>>();
    final defaultTheme =
        context.select((SettingsCubit<AppSettings> c) => c.state.mode) ==
                ThemeMode.dark
            ? BibleViewSettings.defaultThemeDark()
            : BibleViewSettings.defaultThemeLight();

    return Row(
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
                        label: 'Use app\'s theme',
                        description:
                            'Use app\'s theme and its colorscheme. To use custom colors, disabled this.',
                        settingWidth: 100,
                        child: AppInputBool(
                          value: context.select(
                              (SettingsCubit<BibleViewSettings> c) =>
                                  c.state.useAppTheme),
                          onChanged: (val) {
                            cubit.update((p) => p.copyWith(useAppTheme: val));
                          },
                        )),
                    Setting(
                        label: 'Background color',
                        description: 'Set color for the background',
                        child: AppInputColor(
                          showReset: defaultTheme.backgroundColor !=
                              context.select(
                                  (SettingsCubit<BibleViewSettings> c) =>
                                      c.state.backgroundColor),
                          onReset: () {
                            cubit.update((a) => a.copyWith(
                                backgroundColor: defaultTheme.backgroundColor));
                          },
                          isDisabled: !context.select(
                              (SettingsCubit<BibleViewSettings> c) =>
                                  c.state.useAppTheme),
                          onColorChanged: (c) {
                            cubit.update((p) => p.copyWith(backgroundColor: c));
                          },
                          color: context.select(
                            (SettingsCubit<BibleViewSettings> c) =>
                                c.state.backgroundColor,
                          ),
                        )),
                    Setting(
                        label: 'Reference color',
                        description:
                            'Set color for the verse reference (unselected)',
                        child: AppInputColor(
                          showReset: defaultTheme.refColor !=
                              context.select(
                                  (SettingsCubit<BibleViewSettings> c) =>
                                      c.state.refColor),
                          onReset: () {
                            cubit.update((a) =>
                                a.copyWith(refColor: defaultTheme.refColor));
                          },
                          isDisabled: !context.select(
                              (SettingsCubit<BibleViewSettings> c) =>
                                  c.state.useAppTheme),
                          onColorChanged: (c) {
                            cubit.update((p) => p.copyWith(refColor: c));
                          },
                          color: context.select(
                            (SettingsCubit<BibleViewSettings> c) =>
                                c.state.refColor,
                          ),
                        )),
                    Setting(
                        label: 'Text color',
                        description: 'Set color for the verse text',
                        child: AppInputColor(
                          showReset: defaultTheme.verseColor !=
                              context.select(
                                  (SettingsCubit<BibleViewSettings> c) =>
                                      c.state.verseColor),
                          onReset: () {
                            cubit.update((a) => a.copyWith(
                                verseColor: defaultTheme.verseColor));
                          },
                          isDisabled: !context.select(
                              (SettingsCubit<BibleViewSettings> c) =>
                                  c.state.useAppTheme),
                          onColorChanged: (c) {
                            cubit.update((p) => p.copyWith(verseColor: c));
                          },
                          color: context.select(
                            (SettingsCubit<BibleViewSettings> c) =>
                                c.state.verseColor,
                          ),
                        )),
                    // Setting(
                    //     label: 'Horizontal padding',
                    //     description: 'Set horizontal padding',
                    //     child: AppInputNumber(
                    //       suffixIcon: Icons.percent,
                    //       min: 0,
                    //       max: 100,
                    //       onSubmitted: (n) {
                    //         cubit.update(
                    //              (p) =>
                    //                 p.copyWith(generalViewSettings: cubit.state.copyWith(xPadding: n / 100));
                    //       },
                    //       value: context.select(
                    //         (SettingsCubit<BibleViewSettings> c) =>
                    //             (c.state.xPadding * 100),
                    //       ),
                    //     )),
                  ],
                ),
                SettingSection(
                  title: 'Render options',
                  children: [
                    Setting(
                        label: 'Quote color',
                        description: 'Set color for the verse text',
                        child: AppInputColor(
                          showReset: defaultTheme.quoteColor !=
                              context.select(
                                  (SettingsCubit<BibleViewSettings> c) =>
                                      c.state.quoteColor),
                          onReset: () {
                            cubit.update((a) => a.copyWith(
                                quoteColor: defaultTheme.quoteColor));
                          },
                          onColorChanged: (c) {
                            cubit.update((p) => p.copyWith(quoteColor: c));
                          },
                          color: context.select(
                            (SettingsCubit<BibleViewSettings> c) =>
                                c.state.quoteColor,
                          ),
                        )),
                    Setting(
                        label: 'Add color',
                        description: 'Set color for added words',
                        child: AppInputColor(
                          showReset: defaultTheme.addColor !=
                              context.select(
                                  (SettingsCubit<BibleViewSettings> c) =>
                                      c.state.addColor),
                          onReset: () {
                            cubit.update((a) =>
                                a.copyWith(addColor: defaultTheme.addColor));
                          },
                          onColorChanged: (c) {
                            cubit.update((p) => p.copyWith(addColor: c));
                          },
                          color: context.select(
                            (SettingsCubit<BibleViewSettings> c) =>
                                c.state.addColor,
                          ),
                        )),
                  ],
                ),
                SettingSection(
                  title: 'Typography',
                  children: [
                    SettingSection(title: 'Font weight', children: [
                      Setting(
                          label: 'Text font weight',
                          description: 'Set font weight for verse text',
                          child: AppInputOption<BibleViewFontWeight>(
                            value: context.select(
                                (SettingsCubit<BibleViewSettings> c) =>
                                    c.state.verseFontWeight),
                            onChanged: (fw) {
                              cubit.update(
                                  (p) => p.copyWith(verseFontWeight: fw));
                            },
                            items: BibleViewFontWeight.values
                                .map((fw) =>
                                    AppDropdownItem<BibleViewFontWeight>(
                                        value: fw, label: fw.wire))
                                .toList(),
                          )),
                      Setting(
                          label: 'Reference font weight',
                          description:
                              'Set font weight for unselected references',
                          child: AppInputOption<BibleViewFontWeight>(
                            value: context.select(
                                (SettingsCubit<BibleViewSettings> c) =>
                                    c.state.refFontWeight),
                            onChanged: (fw) {
                              cubit
                                  .update((p) => p.copyWith(refFontWeight: fw));
                            },
                            items: BibleViewFontWeight.values
                                .map((fw) =>
                                    AppDropdownItem<BibleViewFontWeight>(
                                        value: fw, label: fw.wire))
                                .toList(),
                          )),
                      Setting(
                          label: 'Selected reference font weight',
                          description:
                              'Set font weight for selected references',
                          child: AppInputOption<BibleViewFontWeight>(
                            value: context.select(
                                (SettingsCubit<BibleViewSettings> c) =>
                                    c.state.selectedRefFontWeight),
                            onChanged: (fw) {
                              cubit.update(
                                  (p) => p.copyWith(selectedRefFontWeight: fw));
                            },
                            items: BibleViewFontWeight.values
                                .map((fw) =>
                                    AppDropdownItem<BibleViewFontWeight>(
                                        value: fw, label: fw.wire))
                                .toList(),
                          )),
                    ]),
                    SettingSection(
                      title: 'Font family',
                      children: [
                        Setting(
                          label: 'Text font',
                          description: 'Set font for the verse text',
                          child: FontPicker(
                            selected: kAppFonts.firstWhere((f) =>
                                f.family ==
                                context.select(
                                  (SettingsCubit<BibleViewSettings> c) =>
                                      c.state.verseFontFamily,
                                )),
                            onChanged: (appFont) => cubit.update((p) =>
                                p.copyWith(verseFontFamily: appFont.family)),
                          ),
                        ),
                        Setting(
                          label: 'Reference font',
                          description: 'Set font for the reference text',
                          child: FontPicker(
                            selected: kAppFonts.firstWhere((f) =>
                                f.family ==
                                context.select(
                                  (SettingsCubit<BibleViewSettings> c) =>
                                      c.state.refFontFamily,
                                )),
                            onChanged: (appFont) => cubit.update((p) =>
                                p.copyWith(refFontFamily: appFont.family)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SettingSection(
                  title: 'Behavior',
                  children: [
                    Setting(
                        label:
                            'Enable auto scroll to verse for bible list view',
                        description:
                            'Automatically scrolls to selected verse when it is out of view',
                        child: AppInputBool(
                          value: context.select(
                              (SettingsCubit<BibleViewSettings> c) =>
                                  c.state.enableAutoScrollToVerse),
                          onChanged: (val) {
                            context
                                .read<SettingsCubit<BibleViewSettings>>()
                                .update((s) =>
                                    s.copyWith(enableAutoScrollToVerse: val));
                          },
                        )),
                    Setting(
                        label: 'Enable strong words selection',
                        description:
                            'Shows a subtle dotted underline for strong words. If clicked, it shows more information',
                        settingWidth: 100,
                        child: AppInputBool(
                          value: context.select(
                              (SettingsCubit<BibleViewSettings> c) =>
                                  c.state.enableStrongWordsRender),
                          onChanged: (val) {
                            cubit.update((p) =>
                                p.copyWith(enableStrongWordsRender: val));
                          },
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
                        child: AppInputNumber(
                          min: 0,
                          max: 256,
                          onSubmitted: (n) {
                            cubit.update((p) =>
                                p.copyWith(splitscreenGap: n.toDouble()));
                          },
                          value: context.select(
                            (SettingsCubit<BibleViewSettings> c) =>
                                c.state.splitscreenGap,
                          ),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
