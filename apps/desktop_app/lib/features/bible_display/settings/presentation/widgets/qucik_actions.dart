import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/settings/global_settings.dart';
import '../../../../../core/settings/settings_cubit.dart';
import '../../../../../shared/widgets/action_button_with_feedback.dart';
import '../../../../settings_window/presentation/widgets/setting_option.dart';
import '../../../../settings_window/presentation/widgets/setting_section.dart';
import '../../bible_view_settings.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  BibleViewSettings _getDefaults(BuildContext context) {
    final themeMode = context.read<SettingsCubit<GlobalSettings>>().state.mode;
    return themeMode == ThemeMode.dark
        ? BibleViewSettings.defaultThemeDark()
        : BibleViewSettings.defaultThemeLight();
  }

  void _resetColors(BuildContext context) {
    final defaults = _getDefaults(context);
    context.read<SettingsCubit<BibleViewSettings>>().update(
          (s) => s.copyWith(
            addColor: defaults.addColor,
            refColor: defaults.refColor,
            quoteColor: defaults.quoteColor,
            verseColor: defaults.verseColor,
            pericopeColor: defaults.pericopeColor,
            backgroundColor: defaults.backgroundColor,
            selectedRefColor: defaults.selectedRefColor,
            verseDividerColor: defaults.verseDividerColor,
          ),
        );
  }

  void _resetEverything(BuildContext context) {
    final defaults = _getDefaults(context);
    context.read<SettingsCubit<BibleViewSettings>>().update((s) => defaults);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingSection(
          children: [
            SettingOption(
              label: 'Reset colors',
              description:
                  'Reset all colors options to match the app theme (dark or light mode)',
              child: ActionButtonWithFeedback(
                onPressed: () => _resetColors(context),
                label: 'Reset colors',
                successLabel: 'Colors reset',
                buttonBuilder: (onPressed, icon, label) {
                  return TextButton.icon(
                    onPressed: onPressed,
                    icon: icon,
                    label: label,
                  );
                },
              ),
            ),
            SettingOption(
              label: 'Reset everything',
              description: 'Reset everything to their default values',
              child: ActionButtonWithFeedback(
                onPressed: () => _resetEverything(context),
                label: 'Reset all',
                successLabel: 'Reset',
                buttonBuilder: (onPressed, icon, label) {
                  return TextButton.icon(
                    onPressed: onPressed,
                    icon: icon,
                    label: label,
                  );
                },
              ),
            )
          ],
        )
      ],
    );
  }
}
