import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/customizer/domain/entities/highlight_render_mode.dart';
import 'package:open_scripture/features/customizer/presentation/state/customizer_cubit.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_input_bool.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_input_number.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_input_option.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_section.dart';

class BibleViewListCustomizerScreen extends StatefulWidget {
  const BibleViewListCustomizerScreen({super.key, this.showPreview = false});

  final bool showPreview;

  @override
  State<BibleViewListCustomizerScreen> createState() =>
      _BibleViewListCustomizerScreenState();
}

class _BibleViewListCustomizerScreenState
    extends State<BibleViewListCustomizerScreen> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CustomizerCubit>();

    return Expanded(
      flex: 2,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(0, 0, 24, 0),
        child: Column(
          children: [
            SettingSection(
              title: 'Options',
              children: [
                Setting(
                    label: 'Show verse divider',
                    description: 'Show divider between verses',
                    child: SettingInputBool(
                      value: context.select(
                        (CustomizerCubit c) =>
                            c.state.listTheme.showVerseDivider,
                      ),
                      onChanged: (val) {
                        cubit.updateTheme(
                            listTheme: (l) =>
                                l.copyWith(showVerseDivider: val));
                      },
                    )),
                Setting(
                    label: 'Show full ref',
                    description:
                        'Show full verse reference or only verse number',
                    child: SettingInputBool(
                      value: context.select(
                        (CustomizerCubit c) =>
                            c.state.listTheme.showFullRefAlways,
                      ),
                      onChanged: (val) {
                        cubit.updateTheme(
                            listTheme: (l) =>
                                l.copyWith(showFullRefAlways: val));
                      },
                    )),
                Setting(
                    label: 'Use hanging refs',
                    description: 'Enables hanging refs',
                    child: SettingInputBool(
                      value: context.select((CustomizerCubit c) =>
                          c.state.listTheme.enableHangingRefs),
                      onChanged: (val) {
                        cubit.updateTheme(
                            listTheme: (l) =>
                                l.copyWith(enableHangingRefs: val));
                      },
                    )),
                Setting(
                    label: 'Underline all references',
                    description: 'Put underline decoration on all references',
                    child: SettingInputBool(
                      value: context.select((CustomizerCubit c) =>
                          c.state.listTheme.underlineRef),
                      onChanged: (val) {
                        cubit.updateTheme(
                            listTheme: (p) => p.copyWith(underlineRef: val));
                      },
                    )),
                Setting(
                    label: 'Selected verses render mode',
                    description: 'How selected verses are rendered',
                    child: SettingInputOption<HighlightRenderMode>(
                      value: context.select((CustomizerCubit c) =>
                          c.state.listTheme.highlightRenderMode),
                      onChanged: (mode) {
                        cubit.updateTheme(
                            listTheme: (l) =>
                                l.copyWith(highlightRenderMode: mode));
                      },
                      items: HighlightRenderMode.values
                          .map((m) => DropdownMenuItem<HighlightRenderMode>(
                              value: m, child: Text(m.wire)))
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
                  child: SettingInputNumber(
                    max: 300,
                    min: 0,
                    value: context.select((CustomizerCubit c) =>
                        c.state.listTheme.parallelSpacing),
                    onSubmitted: (val) => cubit.updateTheme(
                        listTheme: (l) => l.copyWith(
                              parallelSpacing: val.toInt(),
                            )),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
