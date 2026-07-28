import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/settings/settings_cubit.dart';
import '../../../../shared/widgets/ui/inputs/app_input_bool.dart';
import '../../../../shared/widgets/ui/inputs/app_input_number.dart';
import '../../../bible_display/settings/bible_view_settings.dart';
import '../../../settings_window/presentation/widgets/setting.dart';
import '../../../settings_window/presentation/widgets/setting_section.dart';

class BibleViewProseCustomizerScreen extends StatefulWidget {
  const BibleViewProseCustomizerScreen({super.key});

  @override
  State<BibleViewProseCustomizerScreen> createState() =>
      _BibleViewProseCustomizerScreenState();
}

class _BibleViewProseCustomizerScreenState
    extends State<BibleViewProseCustomizerScreen> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit<BibleViewSettings>>();

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(0, 0, 24, 0),
      child: Column(
        children: [
          SettingSection(
            title: 'Options',
            children: [
              Setting(
                label: 'Emphasize selected verses',
                description: 'It reduce opacity for unselected verses',
                child: AppInputBool(
                  value: context.select(
                    (SettingsCubit<BibleViewSettings> c) =>
                        c.state.emphasizeSelectedVerses,
                  ),
                  onChanged: (val) {
                    cubit.update(
                        (s) => s.copyWith(emphasizeSelectedVerses: val));
                  },
                ),
              ),
              Setting(
                label: 'Opacity level of unselected',
                description:
                    'Opacity level of unselected verses when emphasize selected verses is enabled',
                child: AppInputNumber(
                  max: 100,
                  min: 1,
                  value: context.select((SettingsCubit<BibleViewSettings> c) =>
                          c.state.unselectedOpacityLevel) *
                      100,
                  onSubmitted: (val) => cubit.update((s) => s.copyWith(
                        unselectedOpacityLevel: val / 100,
                      )),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
