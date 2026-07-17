import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/widgets/ui/inputs/app_input_bool.dart';
import '../../../settings_window/presentation/widgets/setting.dart';
import '../../../settings_window/presentation/widgets/setting_section.dart';
import '../state/customizer_cubit.dart';

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
    final cubit = context.read<CustomizerCubit>();

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
                    (CustomizerCubit c) =>
                        c.state.proseTheme.emphasizeSelectedVerses,
                  ),
                  onChanged: (val) {
                    cubit.updateTheme(
                        proseTheme: (p) =>
                            p.copyWith(emphasizeSelectedVerses: val));
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
