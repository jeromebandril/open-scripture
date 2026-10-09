import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/settings/settings_cubit.dart';
import '../../../../../shared/domain/entities/display_options.dart';
import '../../../../../shared/presentation/models/display_option_flutter.dart';
import '../../../../../shared/presentation/widgets/ui/inputs/app_input_number.dart';
import '../../../../../shared/presentation/widgets/ui/inputs/app_input_option.dart';
import '../../../../settings_window/presentation/widgets/setting_option.dart';
import '../../../../settings_window/presentation/widgets/setting_section.dart';
import '../../bible_view_settings.dart';
import '../../domain/entities/bible_view_options.dart';

class BibleViewPresentationSettingsTab extends StatefulWidget {
  const BibleViewPresentationSettingsTab({super.key, this.showPreview = false});

  final bool showPreview;

  @override
  State<BibleViewPresentationSettingsTab> createState() =>
      _BibleViewPresentationSettingsTabState();
}

class _BibleViewPresentationSettingsTabState
    extends State<BibleViewPresentationSettingsTab> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit<BibleViewSettings>>();

    return SingleChildScrollView(
      child: Column(
        children: [
          SettingSection(
            title: 'Options',
            children: [
              SettingOption(
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
                            value: fw, label: fw.name))
                        .toList(),
                  )),
              SettingOption(
                  label: 'Title alignment',
                  description: 'Select title alignment',
                  child: AppInputOption<AppTextAlign>(
                    value: context.select(
                        (SettingsCubit<BibleViewSettings> c) =>
                            c.state.presentationTitleTextAlign),
                    onChanged: (ta) {
                      cubit.update(
                          (s) => s.copyWith(presentationTitleTextAlign: ta));
                    },
                    items: AppTextAlign.values
                        .map((ta) => AppDropdownItem<AppTextAlign>(
                            value: ta, label: ta.name, leading: Icon(ta.icon)))
                        .toList(),
                  )),
              SettingOption(
                  label: 'Text alignment',
                  description: 'Select text alignment',
                  child: AppInputOption<AppTextAlign>(
                    value: context.select(
                        (SettingsCubit<BibleViewSettings> c) =>
                            c.state.presentationSubtitleTextAlign),
                    onChanged: (ta) {
                      cubit.update(
                          (s) => s.copyWith(presentationSubtitleTextAlign: ta));
                    },
                    items: AppTextAlign.values
                        .map((ta) => AppDropdownItem<AppTextAlign>(
                            value: ta, label: ta.name, leading: Icon(ta.icon)))
                        .toList(),
                  )),
              SettingOption(
                  label: 'Verse number style',
                  description: 'Select verse number style',
                  child: AppInputOption<InlineVerseNumberStyle>(
                    value: context.select(
                        (SettingsCubit<BibleViewSettings> c) =>
                            c.state.inlineVerseNumberStyle),
                    onChanged: (vns) {
                      cubit.update(
                          (s) => s.copyWith(inlineVerseNumberStyle: vns));
                    },
                    items: InlineVerseNumberStyle.values
                        .map((vns) => AppDropdownItem<InlineVerseNumberStyle>(
                            value: vns, label: vns.name))
                        .toList(),
                  )),
            ],
          ),
          SettingSection(
            title: 'Parallel view options',
            children: [
              SettingOption(
                  label: 'Spacing',
                  description:
                      'The spacing/distance between each parallel instance',
                  child: AppInputNumber(
                    min: 0,
                    max: 100,
                    onSubmitted: (n) {
                      cubit.update((p) => p.copyWith(
                          presentationParallelSpacing: n.toDouble()));
                    },
                    value: context.select(
                      (SettingsCubit<BibleViewSettings> c) =>
                          (c.state.presentationParallelSpacing),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
