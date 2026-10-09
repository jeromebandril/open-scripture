import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/settings/global_settings.dart';
import '../../../../../core/settings/settings_cubit.dart';
import '../../../../../shared/presentation/widgets/ui/inputs/app_input_color/app_input_color.dart';
import '../../../../settings_window/presentation/widgets/setting_option.dart';
import '../../../../settings_window/presentation/widgets/setting_section.dart';
import '../../bible_view_settings.dart';

class StrongWordCustomizationPage extends StatelessWidget {
  const StrongWordCustomizationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit<BibleViewSettings>>();
    final defaultTheme =
        context.select((SettingsCubit<GlobalSettings> c) => c.state.mode) ==
                ThemeMode.dark
            ? BibleViewSettings.defaultThemeDark()
            : BibleViewSettings.defaultThemeLight();

    return SingleChildScrollView(
      child: SettingSection(
        children: [
          SettingOption(
              label: 'Strong word underline color',
              description: 'Set color for the underline below strong words',
              child: AppInputColor(
                showReset: defaultTheme.strongWordsUnderlineColor !=
                    context.select((SettingsCubit<BibleViewSettings> c) =>
                        c.state.strongWordsUnderlineColor),
                onReset: () {
                  cubit.update((a) => a.copyWith(
                      strongWordsUnderlineColor:
                          defaultTheme.strongWordsUnderlineColor));
                },
                onColorChanged: (c) {
                  cubit.update((p) => p.copyWith(strongWordsUnderlineColor: c));
                },
                color: context.select(
                  (SettingsCubit<BibleViewSettings> c) =>
                      c.state.strongWordsUnderlineColor,
                ),
                enableAlpha: true,
              )),
        ],
      ),
    );
  }
}
