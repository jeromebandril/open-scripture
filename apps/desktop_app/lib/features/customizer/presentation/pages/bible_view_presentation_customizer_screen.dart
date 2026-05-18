import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/bible_display/bible_pane/domain/display_mode.dart';
import 'package:open_scripture/features/customizer/domain/entities/app_text_align.dart';
import 'package:open_scripture/features/customizer/presentation/widgets/bible_pane_preview.dart';

import '../../../settings_window/presentation/widgets/setting.dart';
import '../../../settings_window/presentation/widgets/setting_input_number.dart';
import '../../../settings_window/presentation/widgets/setting_input_option.dart';
import '../../../settings_window/presentation/widgets/setting_section.dart';
import '../../domain/entities/app_font_weight.dart';
import '../../domain/entities/presentation_verse_number_style.dart';
import '../state/customizer_cubit.dart';

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
                        label: 'Text Font Weight Subtitle',
                        description:
                            'Set font weight for the bible metadata indicator when in parallel view',
                        child: SettingInputOption<AppFontWeight>(
                          value: context.select((CustomizerCubit c) =>
                              c.state.presentTheme.subtitleFontWeight),
                          onChanged: (fw) {
                            cubit.updateTheme(
                                presentTheme: (p) =>
                                    p.copyWith(subtitleFontWeight: fw));
                          },
                          items: AppFontWeight.values
                              .map((fw) => DropdownMenuItem<AppFontWeight>(
                                  value: fw, child: Text(fw.wire)))
                              .toList(),
                        )),
                    Setting(
                        label: 'Title alignment',
                        description: 'Select title alignment',
                        child: SettingInputOption<AppTextAlign>(
                          value: context.select((CustomizerCubit c) =>
                              c.state.presentTheme.titleTextAlign),
                          onChanged: (ta) {
                            cubit.updateTheme(
                                presentTheme: (p) =>
                                    p.copyWith(titleTextAlign: ta));
                          },
                          items: AppTextAlign.values
                              .map((ta) => DropdownMenuItem<AppTextAlign>(
                                  value: ta, child: Text(ta.wire)))
                              .toList(),
                        )),
                    Setting(
                        label: 'Text alignment',
                        description: 'Select text alignment',
                        child: SettingInputOption<AppTextAlign>(
                          value: context.select((CustomizerCubit c) =>
                              c.state.presentTheme.textAlign),
                          onChanged: (ta) {
                            cubit.updateTheme(
                                presentTheme: (p) => p.copyWith(textAlign: ta));
                          },
                          items: AppTextAlign.values
                              .map((ta) => DropdownMenuItem<AppTextAlign>(
                                  value: ta, child: Text(ta.wire)))
                              .toList(),
                        )),
                    Setting(
                        label: 'Verse number style',
                        description: 'Select verse number style',
                        child: SettingInputOption<PresentationVerseNumberStyle>(
                          value: context.select((CustomizerCubit c) =>
                              c.state.presentTheme.verseNumberStyle),
                          onChanged: (vns) {
                            cubit.updateTheme(
                                presentTheme: (p) =>
                                    p.copyWith(verseNumberStyle: vns));
                          },
                          items: PresentationVerseNumberStyle.values
                              .map((vns) => DropdownMenuItem<
                                      PresentationVerseNumberStyle>(
                                  value: vns, child: Text(vns.wire)))
                              .toList(),
                        )),
                    Setting(
                        label: 'Parallel view distance',
                        description:
                            'Set distance between each parallel instance',
                        child: SettingInputNumber(
                          min: 0,
                          max: 100,
                          onSubmitted: (n) {
                            cubit.updateTheme(
                                presentTheme: (p) =>
                                    p.copyWith(parallelDistance: n.toDouble()));
                          },
                          value: context.select(
                            (CustomizerCubit c) =>
                                (c.state.presentTheme.parallelDistance),
                          ),
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
