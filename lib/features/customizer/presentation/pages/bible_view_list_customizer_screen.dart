import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bible_display/bible_pane/presentation/models/display_mode.dart';
import '../../../settings_window/presentation/widgets/setting.dart';
import '../../../settings_window/presentation/widgets/setting_input_bool.dart';
import '../../../settings_window/presentation/widgets/setting_input_option.dart';
import '../../../settings_window/presentation/widgets/setting_section.dart';
import '../../domain/entities/highlight_render_mode.dart';
import '../cubit/customizer_cubit.dart';
import '../widgets/bible_pane_preview.dart';

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
                        description:
                            'Put underline decoration on all references',
                        child: SettingInputBool(
                          value: context.select((CustomizerCubit c) =>
                              c.state.listTheme.underlineRef),
                          onChanged: (val) {
                            cubit.updateTheme(
                                listTheme: (p) =>
                                    p.copyWith(underlineRef: val));
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
                Center(child: const BiblePanePreview(mode: DisplayMode.normal)),
              ],
            ),
          )
      ],
    );
  }
}
