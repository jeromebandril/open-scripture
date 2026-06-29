import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/customizer/domain/entities/app_font_weight.dart';
import 'package:open_scripture/features/customizer/domain/entities/app_text_align.dart';
import 'package:open_scripture/features/customizer/domain/entities/presentation_verse_number_style.dart';
import 'package:open_scripture/features/customizer/presentation/state/customizer_cubit.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting.dart';
import 'package:open_scripture/shared/widgets/ui/inputs/app_input_number.dart';
import 'package:open_scripture/shared/widgets/ui/inputs/app_input_option.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_section.dart';

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
                    value: context.select((CustomizerCubit c) =>
                        c.state.presentTheme.subtitleFontWeight),
                    onChanged: (fw) {
                      cubit.updateTheme(
                          presentTheme: (p) =>
                              p.copyWith(subtitleFontWeight: fw));
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
                    value: context.select((CustomizerCubit c) =>
                        c.state.presentTheme.titleTextAlign),
                    onChanged: (ta) {
                      cubit.updateTheme(
                          presentTheme: (p) => p.copyWith(titleTextAlign: ta));
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
                        (CustomizerCubit c) => c.state.presentTheme.textAlign),
                    onChanged: (ta) {
                      cubit.updateTheme(
                          presentTheme: (p) => p.copyWith(textAlign: ta));
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
                    value: context.select((CustomizerCubit c) =>
                        c.state.presentTheme.verseNumberStyle),
                    onChanged: (vns) {
                      cubit.updateTheme(
                          presentTheme: (p) =>
                              p.copyWith(verseNumberStyle: vns));
                    },
                    items: PresentationVerseNumberStyle.values
                        .map((vns) =>
                            AppDropdownItem<PresentationVerseNumberStyle>(
                                value: vns, label: vns.wire))
                        .toList(),
                  )),
              Setting(
                  label: 'Parallel view distance',
                  description: 'Set distance between each parallel instance',
                  child: AppInputNumber(
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
    );
  }
}
