import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/settings/settings_cubit.dart';
import '../../../../../shared/widgets/ui/inputs/app_input_bool.dart';
import '../../../../../shared/widgets/ui/inputs/app_input_number.dart';
import '../../../../../shared/widgets/ui/inputs/app_input_option.dart';
import '../../../../settings_window/presentation/widgets/setting.dart';
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

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(0, 0, 24, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SettingSection(
            title: 'Options',
            children: [
              Setting(
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
              Setting(
                  label: 'Show full ref',
                  description: 'Show full verse reference or only verse number',
                  child: AppInputBool(
                    value: context.select(
                      (SettingsCubit<BibleViewSettings> c) =>
                          c.state.showFullRefAlways,
                    ),
                    onChanged: (val) {
                      cubit.update((s) => s.copyWith(showFullRefAlways: val));
                    },
                  )),
              Setting(
                  label: 'Underline all references',
                  description: 'Put underline decoration on all references',
                  child: AppInputBool(
                    value: context.select(
                        (SettingsCubit<BibleViewSettings> c) =>
                            c.state.underlineRef),
                    onChanged: (val) {
                      cubit.update((s) => s.copyWith(underlineRef: val));
                    },
                  )),
              Setting(
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
            ],
          ),
          SettingSection(
            title: 'Parallel view options',
            children: [
              Setting(
                label: 'Spacing',
                description:
                    'The spacing/distance between each column in the parallel view',
                child: AppInputNumber(
                  max: 300,
                  min: 0,
                  value: context.select((SettingsCubit<BibleViewSettings> c) =>
                      c.state.parallelSpacing),
                  onSubmitted: (val) => cubit.update((l) => l.copyWith(
                        parallelSpacing: val.toInt(),
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
