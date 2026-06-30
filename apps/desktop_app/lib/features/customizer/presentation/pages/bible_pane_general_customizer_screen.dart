import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/widgets/font_picker.dart';
import '../../../../shared/fonts/app_font.dart';
import '../../../../shared/widgets/ui/inputs/app_input_bool.dart';
import '../../../../shared/widgets/ui/inputs/app_input_color.dart';
import '../../../../shared/widgets/ui/inputs/app_input_number.dart';
import '../../../../shared/widgets/ui/inputs/app_input_option.dart';
import '../../../settings_window/presentation/widgets/setting.dart';
import '../../../settings_window/presentation/widgets/setting_section.dart';
import '../../domain/entities/app_font_weight.dart';
import '../../domain/entities/bible_pane_general_theme_settings.dart';
import '../state/customizer_cubit.dart';

class BiblePaneGeneralCustomizerScreen extends StatefulWidget {
  const BiblePaneGeneralCustomizerScreen({super.key, this.showPreview = false});

  final bool showPreview;

  @override
  State<BiblePaneGeneralCustomizerScreen> createState() =>
      _BiblePaneGeneralCustomizerScreenState();
}

class _BiblePaneGeneralCustomizerScreenState
    extends State<BiblePaneGeneralCustomizerScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CustomizerCubit>();
    final defaultPaneTheme =
        context.select((CustomizerCubit c) => c.state.app.mode) ==
                ThemeMode.dark
            ? BiblePaneGeneralThemeSettings.dark()
            : BiblePaneGeneralThemeSettings.light();

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
                        label: 'Enable custom colors',
                        description:
                            'Enables custom color theming or use app\'s theme',
                        child: AppInputBool(
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
                        child: AppInputColor(
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
                            (CustomizerCubit c) => c.state.pane.backgroundColor,
                          ),
                        )),
                    Setting(
                        label: 'Reference color',
                        description:
                            'Set color for the verse reference (unselected)',
                        child: AppInputColor(
                          showReset: defaultPaneTheme.refColor !=
                              context.select(
                                  (CustomizerCubit c) => c.state.pane.refColor),
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
                        child: AppInputColor(
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
                        label: 'Horizontal padding',
                        description: 'Set horizontal padding',
                        child: AppInputNumber(
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
                                (c.state.pane.xPadding * 100),
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
                      child: FontPicker(
                        selected: kAppFonts.firstWhere((f) =>
                            f.family ==
                            context.select(
                              (CustomizerCubit c) => c.state.pane.referenceFont,
                            )),
                        onChanged: (appFont) => cubit.updateTheme(
                            paneTheme: (p) =>
                                p.copyWith(referenceFont: appFont.family)),
                      ),
                    ),
                    Setting(
                        label: 'Reference Font Weight',
                        description:
                            'Set font weight for unselected references',
                        child: AppInputOption<AppFontWeight>(
                          value: context.select((CustomizerCubit c) =>
                              c.state.pane.refFontWeight),
                          onChanged: (fw) {
                            cubit.updateTheme(
                                paneTheme: (p) =>
                                    p.copyWith(refFontWeight: fw));
                          },
                          items: AppFontWeight.values
                              .map((fw) => AppDropdownItem<AppFontWeight>(
                                  value: fw, label: fw.wire))
                              .toList(),
                        )),
                    Setting(
                        label: 'Selected reference Font Weight',
                        description: 'Set font weight for selected references',
                        child: AppInputOption<AppFontWeight>(
                          value: context.select((CustomizerCubit c) =>
                              c.state.pane.selectedRefFontWeight),
                          onChanged: (fw) {
                            cubit.updateTheme(
                                paneTheme: (p) =>
                                    p.copyWith(selectedRefFontWeight: fw));
                          },
                          items: AppFontWeight.values
                              .map((fw) => AppDropdownItem<AppFontWeight>(
                                  value: fw, label: fw.wire))
                              .toList(),
                        )),
                    Setting(
                      label: 'Text Font',
                      description: 'Set font for the verse text',
                      child: FontPicker(
                        selected: kAppFonts.firstWhere((f) =>
                            f.family ==
                            context.select(
                              (CustomizerCubit c) => c.state.pane.textFont,
                            )),
                        onChanged: (appFont) => cubit.updateTheme(
                            paneTheme: (p) =>
                                p.copyWith(textFont: appFont.family)),
                      ),
                    ),
                    Setting(
                        label: 'Text Font Weight',
                        description: 'Set font weight for verse text',
                        child: AppInputOption<AppFontWeight>(
                          value: context.select((CustomizerCubit c) =>
                              c.state.pane.textFontWeight),
                          onChanged: (fw) {
                            cubit.updateTheme(
                                paneTheme: (p) =>
                                    p.copyWith(textFontWeight: fw));
                          },
                          items: AppFontWeight.values
                              .map((fw) => AppDropdownItem<AppFontWeight>(
                                  value: fw, label: fw.wire))
                              .toList(),
                        )),
                  ],
                ),
                SettingSection(
                  title: 'Render options',
                  children: [
                    Setting(
                        label: 'Quote color',
                        description: 'Set color for the verse text',
                        child: AppInputColor(
                          showReset: defaultPaneTheme.quoteColor !=
                              context.select((CustomizerCubit c) =>
                                  c.state.pane.quoteColor),
                          onReset: () {
                            cubit.updateTheme(
                                paneTheme: (a) => a.copyWith(
                                    quoteColor: defaultPaneTheme.quoteColor));
                          },
                          onColorChanged: (c) {
                            cubit.updateTheme(
                                paneTheme: (p) => p.copyWith(quoteColor: c));
                          },
                          color: context.select(
                            (CustomizerCubit c) => c.state.pane.quoteColor,
                          ),
                        )),
                    Setting(
                        label: 'Add color',
                        description: 'Set color for added words',
                        child: AppInputColor(
                          showReset: defaultPaneTheme.addColor !=
                              context.select(
                                  (CustomizerCubit c) => c.state.pane.addColor),
                          onReset: () {
                            cubit.updateTheme(
                                paneTheme: (a) => a.copyWith(
                                    addColor: defaultPaneTheme.addColor));
                          },
                          onColorChanged: (c) {
                            cubit.updateTheme(
                                paneTheme: (p) => p.copyWith(addColor: c));
                          },
                          color: context.select(
                            (CustomizerCubit c) => c.state.pane.addColor,
                          ),
                        )),
                    Setting(
                        label: 'Show underline for strong words',
                        description:
                            'Shows a subtle dotted underline for strong words',
                        child: AppInputBool(
                          value: context.select((CustomizerCubit c) =>
                              c.state.pane.underlineStrongWords),
                          onChanged: (val) {
                            cubit.updateTheme(
                                paneTheme: (p) =>
                                    p.copyWith(underlineStrongWords: val));
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
                          max: 100,
                          onSubmitted: (n) {
                            cubit.updateTheme(
                                paneTheme: (p) =>
                                    p.copyWith(splitscreenGap: n.toInt()));
                          },
                          value: context.select(
                            (CustomizerCubit c) => c.state.pane.splitscreenGap,
                          ),
                        )),
                    Setting(
                        label: 'Show divider',
                        description: 'Shows a line divider between panes',
                        child: AppInputBool(
                          value: context.select((CustomizerCubit c) =>
                              c.state.pane.showSplitscreenDivider),
                          onChanged: (val) {
                            cubit.updateTheme(
                                paneTheme: (p) =>
                                    p.copyWith(showSplitscreenDivider: val));
                          },
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
