import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/settings/global_settings.dart';
import '../../../../../core/settings/settings_cubit.dart';
import '../../../../../shared/widgets/ui/inputs/app_input_bool.dart';
import '../../../../../shared/widgets/ui/inputs/app_input_color/app_input_color.dart';
import '../../../../../shared/widgets/ui/inputs/app_input_number.dart';
import '../../../../../shared/widgets/ui/inputs/app_input_option.dart';
import '../../../../settings_window/presentation/widgets/setting_option.dart';
import '../../../../settings_window/presentation/widgets/setting_section.dart';
import '../../bible_view_settings.dart';
import '../../domain/entities/highlight_render_mode.dart';

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
    final defaultTheme =
        context.select((SettingsCubit<GlobalSettings> c) => c.state.mode) ==
                ThemeMode.dark
            ? BibleViewSettings.defaultThemeDark()
            : BibleViewSettings.defaultThemeLight();

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SettingSection(
            title: 'Options',
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
                  label: 'Verse divider color',
                  description: 'Set color for verse divider',
                  child: AppInputColor(
                    showReset: defaultTheme.verseDividerColor !=
                        context.select((SettingsCubit<BibleViewSettings> c) =>
                            c.state.verseDividerColor),
                    onReset: () {
                      cubit.update((a) => a.copyWith(
                          verseDividerColor: defaultTheme.verseDividerColor));
                    },
                    isDisabled: context.select(
                        (SettingsCubit<BibleViewSettings> c) =>
                            c.state.useAppTheme),
                    onColorChanged: (c) {
                      cubit.update((p) => p.copyWith(verseDividerColor: c));
                    },
                    color: context.select(
                      (SettingsCubit<BibleViewSettings> c) =>
                          c.state.verseDividerColor,
                    ),
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
                            value: m, label: m.wire))
                        .toList(),
                  )),
              SettingOption(
                  label: 'Verse spacing (base)',
                  description: 'Base gap between a verse and the next verse',
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
            ],
          ),
          SettingSection(
            title: 'Parallel view options',
            children: [
              SettingOption(
                label: 'Spacing',
                description:
                    'The spacing/distance between each column in the parallel view',
                child: AppInputNumber(
                  max: 300,
                  min: 0,
                  value: context.select((SettingsCubit<BibleViewSettings> c) =>
                      c.state.listParallelSpacing),
                  onSubmitted: (val) => cubit.update((l) => l.copyWith(
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
