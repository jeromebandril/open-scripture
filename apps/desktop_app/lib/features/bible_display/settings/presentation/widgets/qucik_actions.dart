import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../app/settings/global_settings.dart';
import '../../../../../core/settings/settings_cubit.dart';
import '../../../../../shared/presentation/widgets/action_button_with_feedback.dart';
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
            )
          ],
        )
      ],
    );
  }
}
