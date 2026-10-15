import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/settings/settings_cubit.dart';
import '../../../../shared/presentation/widgets/ui/inputs/app_input_bool.dart';
import '../../../../shared/presentation/widgets/ui/inputs/app_input_number.dart';
import '../../../bible_display/settings/bible_view_settings.dart';
import '../../../settings_window/presentation/widgets/setting_option.dart';
import '../../../settings_window/presentation/widgets/setting_section.dart';

class PericopeCustomizationPage extends StatelessWidget {
  const PericopeCustomizationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<SettingsCubit<BibleViewSettings>>(),
      child: Builder(builder: (context) {
        final cubit = context.read<SettingsCubit<BibleViewSettings>>();
        return SingleChildScrollView(
          child: SettingSection(
            children: [
              SettingOption(
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
              SettingOption(
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
              SettingOption(
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
