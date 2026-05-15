import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/bible_display/bible_pane/domain/display_mode.dart';
import 'package:open_scripture/features/customizer/domain/entities/app_font_weight.dart';
import 'package:open_scripture/features/customizer/domain/entities/bible_pane_general_theme_settings.dart';
import 'package:open_scripture/features/customizer/presentation/widgets/bible_pane_preview.dart';
import 'package:open_scripture/features/font_loader/presentation/widgets/font_loader_selector.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_input_bool.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_input_color.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_input_number.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_input_option.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_section.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_input_text.dart';

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
                            (CustomizerCubit c) => c.state.pane.backgroundColor,
                          ),
                        )),
                    Setting(
                        label: 'Reference color',
                        description:
                            'Set color for the verse reference (unselected)',
                        child: SettingInputColor(
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
                        description: 'Set font weight for selected references',
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
                        child: Row(
                          spacing: 4,
                          children: [
                            FontLoaderSelector(),
                            Expanded(
                              child: SettingInputText(
                                prefixIcon: Icons.text_fields_rounded,
                                onSubmitted: (font) {
                                  cubit.updateTheme(
                                      paneTheme: (p) =>
                                          p.copyWith(textFont: font));
                                },
                                value: context.select(
                                  (CustomizerCubit c) => c.state.pane.textFont,
                                ),
                              ),
                            ),
                          ],
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
                  title: 'Render options',
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
                        child: SettingInputColor(
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
                        child: SettingInputBool(
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
                        child: SettingInputNumber(
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
                        child: SettingInputBool(
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
        if (widget.showPreview)
          Expanded(
            flex: 1,
            child: SettingSection.single(
              title: 'Preview',
              child: Center(
                  child: const BiblePanePreview(
                mode: DisplayMode.list,
              )),
            ),
          )
      ],
    );
  }
}
