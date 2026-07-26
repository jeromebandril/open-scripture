import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/settings/settings_cubit.dart';
import '../../../../shared/widgets/ui/inputs/app_input_bool.dart';
import '../../../../shared/widgets/ui/inputs/app_input_color.dart';
import '../../../../shared/widgets/ui/inputs/app_input_number.dart';
import '../../../../shared/widgets/ui/inputs/app_input_option.dart';
import '../../../bible_searchbar/settings/search_settings.dart';
import '../../../settings_window/presentation/widgets/setting.dart';
import '../../../settings_window/presentation/widgets/setting_section.dart';
import '../../domain/entities/bible_pane_general_theme_settings.dart';
import '../state/customizer_cubit.dart';

extension _ThemeModeIcons on ThemeMode {
  IconData get icon {
    switch (this) {
      case ThemeMode.system:
        return Icons.brightness_medium;
      case ThemeMode.light:
        return Icons.light_mode_rounded;
      case ThemeMode.dark:
        return Icons.dark_mode_rounded;
    }
  }
}

class GlobalCustomizerScreen extends StatefulWidget {
  const GlobalCustomizerScreen({super.key});

  @override
  State<GlobalCustomizerScreen> createState() => _GlobalCustomizerScreenState();
}

class _GlobalCustomizerScreenState extends State<GlobalCustomizerScreen> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CustomizerCubit>();

    final defaultPaneTheme =
        context.select((CustomizerCubit c) => c.state.app.mode) ==
                ThemeMode.dark
            ? BiblePaneGeneralThemeSettings.dark()
            : BiblePaneGeneralThemeSettings.light();

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(42, 0, 42, 42),
      child: Column(
        children: [
          SettingSection(
            title: 'Global',
            children: [
              Setting(
                  label: 'Theme',
                  description: 'Set app theme',
                  child: AppInputOption<ThemeMode>(
                    value:
                        context.select((CustomizerCubit c) => c.state.app.mode),
                    onChanged: (mode) {
                      cubit.updateTheme(
                          appTheme: (a) => a.copyWith(mode: mode));
                    },
                    items: ThemeMode.values
                        .map((m) => AppDropdownItem<ThemeMode>(
                            value: m, label: m.name, leading: Icon(m.icon)))
                        .toList(),
                  )),
              Setting(
                  label: 'Accent color',
                  description: 'Set accent color for app',
                  child: AppInputColor(
                    showReset: defaultPaneTheme.accentColor !=
                        context.select(
                            (CustomizerCubit c) => c.state.app.accentColor),
                    onReset: () {
                      cubit.updateTheme(
                          appTheme: (a) => a.copyWith(
                              accentColor: defaultPaneTheme.accentColor));
                    },
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
                  child: AppInputBool(
                    enabled: false,
                    value: false,
                    // value: context.select((CustomizerCubit c) =>
                    //     c.state.app.enableAutoColorScheme),
                    // onChanged: (val) {
                    //   cubit.updateTheme(
                    //       appTheme: (a) =>
                    //           a.copyWith(enableAutoColorScheme: val));
                    // },
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
                  label: 'Enable 3 Tap Navigator',
                  description:
                      'Select book, chapter and verse with consecutive clicks',
                  child: AppInputBool(
                    value: context.select(
                        (CustomizerCubit c) => c.state.app.enable3TapNavigator),
                    onChanged: (val) {
                      cubit.updateTheme(
                          appTheme: (a) =>
                              a.copyWith(enable3TapNavigator: val));
                    },
                  )),
              Setting(
                  label: 'Enable searchbar book suggestions',
                  description:
                      'Shows a dropdown menu, under the searchbar, with book name candidates while typing',
                  child: AppInputBool(
                    value: context.select((SettingsCubit<SearchSettings> c) =>
                        c.state.enableBookSuggestion),
                    onChanged: (val) {
                      context
                          .read<SettingsCubit<SearchSettings>>()
                          .update((s) => s.copyWith(enableBookSuggestion: val));
                    },
                  )),
            ],
          ),
          SettingSection(
            title: 'Advanced',
            children: [
              Setting(
                  label: 'Width adjustment',
                  description: 'Set horizontal padding to fit screen if needed',
                  child: AppInputNumber(
                    min: 0,
                    max: 100,
                    onSubmitted: (n) {
                      cubit.updateTheme(
                          paneTheme: (p) =>
                              p.copyWith(widthAdjustmentOffset: n.toDouble()));
                    },
                    value: context.select(
                      (CustomizerCubit c) => c.state.pane.widthAdjustmentOffset,
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
