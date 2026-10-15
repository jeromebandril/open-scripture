import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/settings/settings_cubit.dart';
import '../../../../features/bible_searchbar/settings/domain/entities/searchbar_appearance_option.dart';
import '../../../../features/bible_searchbar/settings/search_settings.dart';
import '../../../../features/settings_window/presentation/widgets/setting_option.dart';
import '../../../../features/settings_window/presentation/widgets/setting_section.dart';
import '../../../../shared/presentation/widgets/ui/inputs/app_input_bool.dart';
import '../../../../shared/presentation/widgets/ui/inputs/app_input_option.dart';
import '../../global_settings.dart';

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
    final cubit = context.read<SettingsCubit<GlobalSettings>>();

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(42, 0, 42, 42),
      child: Column(
        children: [
          SettingSection(
            title: 'Global',
            children: [
              SettingOption(
                label: 'Theme mode',
                description:
                    'Set app theme. It has effect only on app\'s interface. Bible view colorscheme has its own dedicated customization.',
                child: AppInputOption<ThemeMode>(
                  value: context.select(
                      (SettingsCubit<GlobalSettings> c) => c.state.mode),
                  onChanged: (mode) {
                    cubit.update((a) => a.copyWith(mode: mode));
                  },
                  items: ThemeMode.values
                      .map((m) => AppDropdownItem<ThemeMode>(
                          value: m, label: m.name, leading: Icon(m.icon)))
                      .toList(),
                ),
              ),
              SettingOption(
                label: 'Enable adaptive titlebar',
                description:
                    'Makes titlebar color same as bible viewer background',
                child: AppInputBool(
                  value: context.select((SettingsCubit<GlobalSettings> c) =>
                      c.state.enableAdaptiveTitlebar),
                  onChanged: (val) {
                    cubit
                        .update((a) => a.copyWith(enableAdaptiveTitlebar: val));
                  },
                ),
              ),
            ],
          ),
          SettingSection(
            title: 'Interface',
            children: [
              SettingOption(
                label: 'Enable 3 Tap Navigator',
                description:
                    'Select book, chapter and verse with consecutive clicks',
                child: AppInputBool(
                  value: context.select((SettingsCubit<GlobalSettings> c) =>
                      c.state.enable3TapNavigator),
                  onChanged: (val) {
                    cubit.update((a) => a.copyWith(enable3TapNavigator: val));
                  },
                ),
              ),
              SettingOption(
                label: 'Searchbar appearance',
                description:
                    'Collapsed appearance moves the search bar to the start of the titlebar and collapses it into an icon. Click the icon to expand the search field',
                child: AppInputOption<SearchbarAppearanceOption>(
                  value: context.select((SettingsCubit<SearchSettings> c) =>
                      c.state.searchbarAppearance),
                  onChanged: (val) {
                    context
                        .read<SettingsCubit<SearchSettings>>()
                        .update((a) => a.copyWith(searchbarAppearance: val));
                  },
                  items: SearchbarAppearanceOption.values
                      .map(
                        (opt) => AppDropdownItem<SearchbarAppearanceOption>(
                          value: opt,
                          label: opt.name,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
          SettingSection(
            title: 'Behavior',
            children: [
              SettingOption(
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
