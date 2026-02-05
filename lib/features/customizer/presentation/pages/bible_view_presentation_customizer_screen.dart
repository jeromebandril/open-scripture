import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/models/display_mode.dart';
import 'package:open_scripture/features/customizer/domain/entities/app_text_alignment.dart';
import 'package:open_scripture/features/customizer/presentation/widgets/bible_pane_preview.dart';

import '../../../settings_window/presentation/widgets/setting.dart';
import '../../../settings_window/presentation/widgets/setting_input_option.dart';
import '../../../settings_window/presentation/widgets/setting_section.dart';
import '../cubit/customizer_cubit.dart';

class BibleViewPresentationCustomizerScreen extends StatefulWidget {
  const BibleViewPresentationCustomizerScreen(
      {super.key, this.showPreview = false});

  final bool showPreview;

  @override
  State<BibleViewPresentationCustomizerScreen> createState() =>
      _BibleViewPresentationCustomizerScreenState();
}

class _BibleViewPresentationCustomizerScreenState
    extends State<BibleViewPresentationCustomizerScreen> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CustomizerCubit>();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0, 0, 24, 0),
            child: Column(
              children: [
                SettingSection(
                  title: 'Options',
                  children: [
                    Setting(
                        label: 'Text alignment',
                        description: 'Select text alignment',
                        child: SettingInputOption<AppTextAlignment>(
                          value: context.select((CustomizerCubit c) =>
                              c.state.presentTheme.textAlignment),
                          onChanged: (ta) {
                            cubit.updateTheme(
                                presentTheme: (p) =>
                                    p.copyWith(textAlignment: ta));
                          },
                          items: AppTextAlignment.values
                              .map((ta) => DropdownMenuItem<AppTextAlignment>(
                                  value: ta, child: Text(ta.wire)))
                              .toList(),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (widget.showPreview)
          Expanded(
            flex: 1,
            child: SettingSection(
              title: 'Preview',
              children: [
                Center(
                    child:
                        const BiblePanePreview(mode: DisplayMode.presentation)),
              ],
            ),
          )
      ],
    );
  }
}
