import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/settings/settings_cubit.dart';
import '../../../../../shared/presentation/widgets/ui/inputs/app_input_bool.dart';
import '../../../../../shared/presentation/widgets/ui/inputs/app_input_number.dart';
import '../../../../../shared/presentation/widgets/ui/inputs/app_input_option.dart';
import '../../../../settings_window/presentation/widgets/setting_option.dart';
import '../../../../settings_window/presentation/widgets/setting_section.dart';
import '../../bible_view_settings.dart';
import '../../domain/entities/bible_view_options.dart';

class BibleViewListSettingsTab extends StatefulWidget {
  const BibleViewListSettingsTab({super.key, this.showPreview = false});

  final bool showPreview;

  @override
  State<BibleViewListSettingsTab> createState() =>
      _BibleViewListSettingsTabState();
}

class _BibleViewListSettingsTabState extends State<BibleViewListSettingsTab> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit<BibleViewSettings>>();

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SettingSection(
            title: 'Appearance',
            children: [
              SettingOption(
                  label: 'Show verse divider',
                  description: 'Show divider between verses',
                  child: AppInputBool(
                    value: context.select(
                      (SettingsCubit<BibleViewSettings> c) =>
                          c.state.showVerseDivider,
                    ),
                    onChanged: (val) {
                      cubit.update((l) => l.copyWith(showVerseDivider: val));
                    },
                  )),
              SettingOption(
                  label: 'Show full ref',
                  description: 'Show full verse reference or only verse number',
                  child: AppInputBool(
                    value: context.select(
                      (SettingsCubit<BibleViewSettings> c) =>
                          c.state.showAlwaysFullRef,
                    ),
                    onChanged: (val) {
                      cubit.update((s) => s.copyWith(showAlwaysFullRef: val));
                    },
                  )),
              SettingOption(
                  label: 'Underline all references',
                  description: 'Put underline decoration on all references',
                  child: AppInputBool(
                    value: context.select(
                        (SettingsCubit<BibleViewSettings> c) =>
                            c.state.underlineRefs),
                    onChanged: (val) {
                      cubit.update((s) => s.copyWith(underlineRefs: val));
                    },
                  )),
              SettingOption(
                  label: 'Selected verses render mode',
                  description: 'How selected verses are rendered',
                  child: AppInputOption<HighlightRenderMode>(
                    value: context.select(
                        (SettingsCubit<BibleViewSettings> c) =>
                            c.state.highlightRenderMode),
                    onChanged: (mode) {
                      cubit
                          .update((s) => s.copyWith(highlightRenderMode: mode));
                    },
                    items: HighlightRenderMode.values
                        .map((m) => AppDropdownItem<HighlightRenderMode>(
                            value: m, label: m.label))
                        .toList(),
                  )),
              SettingOption(
                  label: 'Reference text case',
                  description: 'Set verse reference text case',
                  child: AppInputOption<TextCase>(
                    value: context.select(
                        (SettingsCubit<BibleViewSettings> c) =>
                            c.state.listVerseRefCase),
                    onChanged: (tc) {
                      cubit.update((s) => s.copyWith(listVerseRefCase: tc));
                    },
                    items: TextCase.values
                        .map((m) =>
                            AppDropdownItem<TextCase>(value: m, label: m.label))
                        .toList(),
                  )),
              SettingOption(
                  label: 'Reference space after',
                  description:
                      'Set how many <space> are after the verse reference',
                  child: AppInputNumber(
                    max: 8,
                    min: 1,
                    value: context.select(
                        (SettingsCubit<BibleViewSettings> c) =>
                            c.state.listSpaceAfterRef),
                    onChanged: (v) {
                      cubit.update(
                          (s) => s.copyWith(listSpaceAfterRef: v.toInt()));
                    },
                  )),
              SettingOption(
                  label: 'Reference size',
                  description: 'Set verse reference size',
                  child: AppInputOption<UiSize>(
                    value: context.select(
                        (SettingsCubit<BibleViewSettings> c) =>
                            c.state.listRefSize),
                    onChanged: (tc) {
                      cubit.update((s) => s.copyWith(listRefSize: tc));
                    },
                    items: UiSize.values
                        .map((m) =>
                            AppDropdownItem<UiSize>(value: m, label: m.name))
                        .toList(),
                  )),
            ],
          ),
          SettingSection(
            title: 'Layout',
            children: [
              SettingOption(
                  label: 'Verse spacing',
                  description: 'Spacing between a verse and the next',
                  child: AppInputNumber(
                    max: 64,
                    min: 0,
                    value: context.select(
                        (SettingsCubit<BibleViewSettings> c) =>
                            c.state.verseSpacing),
                    onChanged: (v) {
                      cubit.update(
                          (s) => s.copyWith(verseSpacing: v.toDouble()));
                    },
                  )),
              SettingOption(
                label: 'Parallel view spacing',
                description:
                    'The spacing/distance between each column in the parallel view',
                child: AppInputNumber(
                  max: 300,
                  min: 0,
                  value: context.select((SettingsCubit<BibleViewSettings> c) =>
                      c.state.listParallelSpacing),
                  onChanged: (val) => cubit.update((l) => l.copyWith(
                        listParallelSpacing: val.toDouble(),
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
