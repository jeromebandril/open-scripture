import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/settings/settings_cubit.dart';
import '../../../../features/bible_searchbar/settings/search_settings.dart';
import '../../../../features/settings_window/presentation/widgets/setting.dart';
import '../../../../features/settings_window/presentation/widgets/setting_section.dart';
import '../../../../shared/widgets/ui/inputs/app_input_bool.dart';
import '../../../../shared/widgets/ui/inputs/app_input_option.dart';
import '../../app_settings.dart';

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

class GlobalSettingsPage extends StatefulWidget {
  const GlobalSettingsPage({super.key});

  @override
  State<GlobalSettingsPage> createState() => _GlobalSettingsPageState();
}

class _GlobalSettingsPageState extends State<GlobalSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit<AppSettings>>();

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(42, 0, 42, 42),
      child: Column(
        children: [
          SettingSection(
            title: 'Global',
            children: [
              Setting(
                  label: 'Theme mode',
                  description: 'Set app theme',
                  child: AppInputOption<ThemeMode>(
                    value: context
                        .select((SettingsCubit<AppSettings> c) => c.state.mode),
                    onChanged: (mode) {
                      cubit.update((a) => a.copyWith(mode: mode));
                    },
                    items: ThemeMode.values
                        .map((m) => AppDropdownItem<ThemeMode>(
                            value: m, label: m.name, leading: Icon(m.icon)))
                        .toList(),
                  )),
              // Setting(
              //     label: 'Enable uniform background color',
              //     description:
              //         'use bible viewer\'s background color as app color',
              //     child: SettingBoolInput(
              //       value: context.select((SettingsCubit<AppSettings> c) =>
              //           c.state.theme.useBackgroundColorAsAppColor),
              //       onChanged: (val) {
              //         cubit.update((theme) =>
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
                    value: context.select((SettingsCubit<AppSettings> c) =>
                        c.state.enable3TapNavigator),
                    onChanged: (val) {
                      cubit.update((a) => a.copyWith(enable3TapNavigator: val));
                    },
                  )),
            ],
          ),
          SettingSection(
            title: 'Behavior',
            children: [
              Setting(
                  label: 'Enable searchbar book suggestions',
                  description:
                      'Shows a dropdown menu with book name candidates while typing',
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
          // SettingSection(
          //   title: 'Advanced',
          //   children: [
          //     Setting(
          //         label: 'Width adjustment',
          //         description: 'Set horizontal padding to fit screen if needed',
          //         child: AppInputNumber(
          //           min: 0,
          //           max: 100,
          //           onSubmitted: (n) {
          //             cubit.update((p) =>
          //                 p.copyWith(widthAdjustmentOffset: n.toDouble()));
          //           },
          //           value: context.select(
          //             (SettingsCubit<AppSettings> c) =>
          //                 c.state.widthAdjustmentOffset,
          //           ),
          //         )),
          //   ],
          // )
        ],
      ),
    );
  }
}
