import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../app/extensions/build_context_extensions.dart';
import '../../../../../app/settings/global_settings.dart';
import '../../../../../app/widgets/font_picker.dart';
import '../../../../../core/settings/settings_cubit.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../../../../../shared/domain/entities/display_options.dart';
import '../../../../../shared/fonts/app_font.dart';
import '../../../../../shared/presentation/models/display_option_flutter.dart';
import '../../../../../shared/presentation/widgets/action_button_with_feedback.dart';
import '../../../../../shared/presentation/widgets/ui/inputs/app_input_bool.dart';
import '../../../../../shared/presentation/widgets/ui/inputs/app_input_number.dart';
import '../../../../../shared/presentation/widgets/ui/inputs/app_input_option.dart';
import '../../../../pericopes_mgr/presentation/pages/pericope_customization_page.dart';
import '../../../../settings_window/presentation/widgets/setting_option.dart';
import '../../../../settings_window/presentation/widgets/setting_section.dart';
import '../../../bible_pane/domain/display_mode.dart';
import '../../../colorschemes/presentation/widgets/colorscheme_selector.dart';
import '../../bible_view_settings.dart';

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

    final fontWeightItems = AppFontWeight.values
        .map(
          (fw) => AppDropdownItem<AppFontWeight>(
            value: fw,
            label: fw.name,
            leading: Text(
              "Aa",
              style: TextStyle(fontWeight: fw.toFlutter()),
            ),
          ),
        )
        .toList();

    return Row(
      spacing: 16,
      children: [
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SettingSection.single(
                  title: 'Coloscheme',
                  child: const BibleViewColorschemeSelector(),
                ),
                SettingSection(
                  title: 'Typography',
                  children: [
                    SettingSection(title: 'Font weight', children: [
                      SettingOption(
                          label: 'Verse font weight',
                          description: 'Set font weight for verse text',
                          child: AppInputOption<AppFontWeight>(
                            value: context.select(
                                (SettingsCubit<BibleViewSettings> c) =>
                                    c.state.verseFontWeight),
                            onChanged: (fw) {
                              cubit.update(
                                  (p) => p.copyWith(verseFontWeight: fw));
                            },
                            items: fontWeightItems,
                          )),
                      SettingOption(
                          label: 'Reference font weight',
                          description:
                              'Set font weight for unselected references',
                          child: AppInputOption<AppFontWeight>(
                            value: context.select(
                                (SettingsCubit<BibleViewSettings> c) =>
                                    c.state.refFontWeight),
                            onChanged: (fw) {
                              cubit
                                  .update((p) => p.copyWith(refFontWeight: fw));
                            },
                            items: fontWeightItems,
                          )),
                      SettingOption(
                          label: 'Selected reference font weight',
                          description:
                              'Set font weight for selected references',
                          child: AppInputOption<AppFontWeight>(
                            value: context.select(
                                (SettingsCubit<BibleViewSettings> c) =>
                                    c.state.selectedRefFontWeight),
                            onChanged: (fw) {
                              cubit.update(
                                  (p) => p.copyWith(selectedRefFontWeight: fw));
                            },
                            items: fontWeightItems,
                          )),
                    ]),
                    SettingSection(
                      title: 'Font family',
                      children: [
                        SettingOption(
                          label: 'Verse font family',
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
                        SettingOption(
                          label: 'Reference font family',
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
                    SettingSection(title: 'Advanced', children: [
                      SettingOption(
                          label: 'Use custom text letter spacing',
                          description:
                              'Can set custom letter spacing or use default specified from the font family itself',
                          child: AppInputBool(
                            value: context.select(
                                    (SettingsCubit<BibleViewSettings> c) =>
                                        c.state.verseLetterSpacing) !=
                                null,
                            onChanged: (val) {
                              final s = val ? 0.0 : null;
                              cubit.update((p) =>
                                  p.copyWith(verseLetterSpacing: () => s));
                            },
                          )),
                      SettingOption(
                          label: 'Text letter spacing',
                          description:
                              'Set distance between letters (can be negative)',
                          child: AppInputNumber(
                            enabled: context.select(
                                    (SettingsCubit<BibleViewSettings> c) =>
                                        c.state.verseLetterSpacing) !=
                                null,
                            min: -10,
                            max: 10,
                            decimal: true,
                            onSubmitted: (n) {
                              cubit.update((p) => p.copyWith(
                                  verseLetterSpacing: () => n.toDouble()));
                            },
                            value: context.select(
                              (SettingsCubit<BibleViewSettings> c) =>
                                  c.state.verseLetterSpacing,
                            ),
                          )),
                    ]),
                  ],
                ),
                SettingSection(
                  title: 'Content',
                  children: [
                    SettingOption(
                        label: 'Render pericope headings',
                        description:
                            'Render pericope headings if available in the bible text, or use default headings',
                        settingWidth: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          spacing: AppSpacing.sm,
                          children: [
                            IconButton(
                              onPressed: () => context.pushStandardWindow(
                                title: 'Pericope customization',
                                maxSize: const Size(600, 400),
                                builder: (_) =>
                                    const PericopeCustomizationPage(),
                              ),
                              icon: const Icon(LucideIcons.settings),
                            ),
                            AppInputBool(
                              value: context.select(
                                  (SettingsCubit<BibleViewSettings> c) =>
                                      c.state.enablePericope),
                              onChanged: (val) {
                                cubit.update(
                                    (p) => p.copyWith(enablePericope: val));
                              },
                            ),
                          ],
                        )),
                  ],
                ),
                SettingSection(
                  title: 'Behavior',
                  children: [
                    SettingOption(
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
                    SettingOption(
                      label: 'Enable strong words selection',
                      description:
                          'Shows a subtle dotted underline for strong words. If clicked, it shows more information',
                      settingWidth: 100,
                      child: AppInputBool(
                        value: context.select(
                            (SettingsCubit<BibleViewSettings> c) =>
                                c.state.enableStrongWordsRender),
                        onChanged: (val) {
                          cubit.update(
                              (p) => p.copyWith(enableStrongWordsRender: val));
                        },
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   spacing: AppSpacing.sm,
                      //   children: [
                      //     IconButton(
                      //       onPressed: () => context.pushStandardWindow(
                      //         title: 'Strong word customization',
                      //         maxSize: const Size(600, 400),
                      //         builder: (_) =>
                      //             const StrongWordCustomizationPage(),
                      //       ),
                      //       icon: const Icon(LucideIcons.settings),
                      //     ),
                      //   ],
                      // ),
                    ),
                  ],
                ),
                SettingSection(
                  title: 'Other options',
                  children: [
                    SettingOption(
                        label: 'Splitscreen spacing gap',
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
                    SettingOption(
                      label: 'Enabled view modes',
                      description: 'Enabled view modes',
                      child: AppInputOption.multiple(
                        items: DisplayMode.values
                            .map(
                                (d) => AppDropdownItem(value: d, label: d.name))
                            .toList(),
                        values: context.select(
                            (SettingsCubit<BibleViewSettings> c) =>
                                c.state.enabledDisplayModes),
                        numOfItemsInLabel: 3,
                        valuesValidator: (candidate) => candidate.isNotEmpty,
                        invalidSelectionMessage: 'Can\'t be empty',
                        onValuesChanged: (v) {
                          cubit.update(
                              (p) => p.copyWith(enabledDisplayModes: v));
                          // this affects also default view mode
                          if (!v.contains(cubit.state.defaultDisplayMode)) {
                            cubit.update(
                                (p) => p.copyWith(defaultDisplayMode: v.first));
                          }
                        },
                      ),
                    ),
                    SettingOption(
                      label: 'Default view mode',
                      description:
                          'Default view mode when new bible pane is created',
                      child: AppInputOption(
                        items: DisplayMode.values
                            .map(
                                (d) => AppDropdownItem(value: d, label: d.name))
                            .toList(),
                        value: context.select(
                            (SettingsCubit<BibleViewSettings> c) =>
                                c.state.defaultDisplayMode),
                        validator: (candidate) =>
                            cubit.state.enabledDisplayModes.contains(candidate),
                        invalidSelectionMessage:
                            'Select a mode that is enabled',
                        onChanged: (v) => cubit
                            .update((p) => p.copyWith(defaultDisplayMode: v)),
                      ),
                    ),
                    const _ResetButton(),
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

class _ResetButton extends StatelessWidget {
  const _ResetButton();

  BibleViewSettings _getDefaults(BuildContext context) {
    final themeMode = context.read<SettingsCubit<GlobalSettings>>().state.mode;
    return themeMode == ThemeMode.dark
        ? BibleViewSettings.defaultThemeDark()
        : BibleViewSettings.defaultThemeLight();
  }

  void _resetEverything(BuildContext context) {
    final defaults = _getDefaults(context);
    context.read<SettingsCubit<BibleViewSettings>>().update((s) => defaults);
  }

  @override
  Widget build(BuildContext context) {
    return SettingOption(
      label: 'Reset everything',
      description: 'Reset everything to their default values',
      child: ActionButtonWithFeedback(
        onPressed: () => _resetEverything(context),
        label: 'Reset all',
        successLabel: 'Reset',
        icon: const Icon(LucideIcons.rotateCcw),
        buttonBuilder: (onPressed, icon, label) {
          return TextButton.icon(
            onPressed: onPressed,
            icon: icon,
            label: label,
          );
        },
      ),
    );
  }
}
