import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/settings/settings_cubit.dart';
import '../../../../shared/widgets/ui/inputs/app_input_number.dart';
import '../../../../shared/widgets/ui/inputs/app_input_option.dart';
import '../../../bible_display/settings/bible_view_settings.dart';
import '../../../settings_window/presentation/widgets/setting.dart';
import '../../../settings_window/presentation/widgets/setting_section.dart';
import '../../domain/entities/app_font_weight.dart';
import '../../domain/entities/app_text_align.dart';
import '../../domain/entities/presentation_verse_number_style.dart';

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
    final cubit = context.read<SettingsCubit<BibleViewSettings>>();

    return SingleChildScrollView(
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
                  child: AppInputOption<AppFontWeight>(
                    value: context.select(
                        (SettingsCubit<BibleViewSettings> c) =>
                            c.state.subtitleFontWeight),
                    onChanged: (fw) {
                      cubit.update((s) => s.copyWith(subtitleFontWeight: fw));
                    },
                    items: AppFontWeight.values
                        .map((fw) => AppDropdownItem<AppFontWeight>(
                            value: fw, label: fw.wire))
                        .toList(),
                  )),
              Setting(
                  label: 'Title alignment',
                  description: 'Select title alignment',
                  child: AppInputOption<AppTextAlign>(
                    value: context.select(
                        (SettingsCubit<BibleViewSettings> c) =>
                            c.state.titleTextAlign),
                    onChanged: (ta) {
                      cubit.update((s) => s.copyWith(titleTextAlign: ta));
                    },
                    items: AppTextAlign.values
                        .map((ta) => AppDropdownItem<AppTextAlign>(
                            value: ta, label: ta.wire, leading: Icon(ta.icon)))
                        .toList(),
                  )),
              Setting(
                  label: 'Text alignment',
                  description: 'Select text alignment',
                  child: AppInputOption<AppTextAlign>(
                    value: context.select(
                        (SettingsCubit<BibleViewSettings> c) =>
                            c.state.textAlign),
                    onChanged: (ta) {
                      cubit.update((s) => s.copyWith(textAlign: ta));
                    },
                    items: AppTextAlign.values
                        .map((ta) => AppDropdownItem<AppTextAlign>(
                            value: ta, label: ta.wire, leading: Icon(ta.icon)))
                        .toList(),
                  )),
              Setting(
                  label: 'Verse number style',
                  description: 'Select verse number style',
                  child: AppInputOption<PresentationVerseNumberStyle>(
                    value: context.select(
                        (SettingsCubit<BibleViewSettings> c) =>
                            c.state.verseNumberStyle),
                    onChanged: (vns) {
                      cubit.update((s) => s.copyWith(verseNumberStyle: vns));
                    },
                    items: PresentationVerseNumberStyle.values
                        .map((vns) =>
                            AppDropdownItem<PresentationVerseNumberStyle>(
                                value: vns, label: vns.wire))
                        .toList(),
                  )),
            ],
          ),
          SettingSection(
            title: 'Parallel view options',
            children: [
              Setting(
                  label: 'Spacing',
                  description:
                      'The spacing/distance between each parallel instance',
                  child: AppInputNumber(
                    min: 0,
                    max: 100,
                    onSubmitted: (n) {
                      cubit.update(
                          (p) => p.copyWith(parallelDistance: n.toDouble()));
                    },
                    value: context.select(
                      (SettingsCubit<BibleViewSettings> c) =>
                          (c.state.parallelDistance),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
