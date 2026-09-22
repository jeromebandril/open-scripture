import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/settings/app_settings.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/settings/settings_cubit.dart';
import '../../../../shared/widgets/ui/inputs/app_input_bool.dart';
import '../../../../shared/widgets/ui/inputs/app_input_color.dart';
import '../../../../shared/widgets/ui/inputs/app_input_number.dart';
import '../../../bible_display/settings/bible_view_settings.dart';
import '../../../settings_window/presentation/widgets/setting.dart';
import '../../../settings_window/presentation/widgets/setting_section.dart';

class PericopeCustomizationPage extends StatelessWidget {
  const PericopeCustomizationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<SettingsCubit<BibleViewSettings>>(),
      child: Builder(builder: (context) {
        final cubit = context.read<SettingsCubit<BibleViewSettings>>();
        final defaultTheme =
            context.select((SettingsCubit<AppSettings> c) => c.state.mode) ==
                    ThemeMode.dark
                ? BibleViewSettings.defaultThemeDark()
                : BibleViewSettings.defaultThemeLight();
        return SingleChildScrollView(
          child: SettingSection(
            children: [
              Setting(
                  label: 'Pericope color',
                  description: 'Set color for the pericope heading',
                  child: AppInputColor(
                    showReset: defaultTheme.pericopeColor !=
                        context.select((SettingsCubit<BibleViewSettings> c) =>
                            c.state.pericopeColor),
                    onReset: () {
                      cubit.update((a) => a.copyWith(
                          pericopeColor: defaultTheme.pericopeColor));
                    },
                    onColorChanged: (c) {
                      cubit.update((p) => p.copyWith(pericopeColor: c));
                    },
                    color: context.select(
                      (SettingsCubit<BibleViewSettings> c) =>
                          c.state.pericopeColor,
                    ),
                  )),
              Setting(
                  label: 'Underline heading',
                  description: 'Underline the pericope heading',
                  child: AppInputBool(
                    value: context.select(
                        (SettingsCubit<BibleViewSettings> c) =>
                            c.state.pericopeUnderline),
                    onChanged: (bool value) {
                      cubit.update((a) => a.copyWith(pericopeUnderline: value));
                    },
                  )),
              Setting(
                  label: 'Spacing above heading',
                  description: 'Set space above the pericope heading',
                  child: AppInputNumber(
                    min: 0,
                    max: 100,
                    decimal: true,
                    onSubmitted: (n) {
                      cubit.update(
                          (p) => p.copyWith(pericopeSpacingTop: n.toDouble()));
                    },
                    value: context.select(
                      (SettingsCubit<BibleViewSettings> c) =>
                          c.state.pericopeSpacingTop,
                    ),
                  )),
              Setting(
                  label: 'Spacing below heading',
                  description: 'Set space below the pericope heading',
                  child: AppInputNumber(
                    min: 0,
                    max: 100,
                    decimal: true,
                    onSubmitted: (n) {
                      cubit.update((p) =>
                          p.copyWith(pericopeSpacingBottom: n.toDouble()));
                    },
                    value: context.select(
                      (SettingsCubit<BibleViewSettings> c) =>
                          c.state.pericopeSpacingBottom,
                    ),
                  )),
            ],
          ),
        );
      }),
    );
  }
}
