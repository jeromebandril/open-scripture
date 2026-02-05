import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/customizer/domain/entities/bible_pane_general_theme_settings.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_input_bool.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_input_color.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_input_number.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_input_option.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_section.dart';

import '../../domain/entities/searchbar_position.dart';
import '../cubit/customizer_cubit.dart';

class GlobalCustomizerScreen extends StatefulWidget {
  const GlobalCustomizerScreen({super.key});

  @override
  State<GlobalCustomizerScreen> createState() => _GlobalCustomizerScreenState();
}

class _GlobalCustomizerScreenState extends State<GlobalCustomizerScreen> {
  final defaultPaneTheme = BiblePaneGeneralThemeSettings();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CustomizerCubit>();

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
                  child: SettingInputOption<ThemeMode>(
                    value:
                        context.select((CustomizerCubit c) => c.state.app.mode),
                    onChanged: (mode) {
                      cubit.updateTheme(
                          appTheme: (a) => a.copyWith(mode: mode));
                    },
                    items: ThemeMode.values
                        .map((m) => DropdownMenuItem<ThemeMode>(
                            value: m, child: Text(m.name)))
                        .toList(),
                  )),
              Setting(
                  label: 'Accent color',
                  description: 'Set accent color for app',
                  child: SettingInputColor(
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
                            value: sp, child: Text(sp.wire)))
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
