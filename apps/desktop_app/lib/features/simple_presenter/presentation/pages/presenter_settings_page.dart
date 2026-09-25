import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/settings/settings_cubit.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../../../shared/widgets/ui/inputs/app_input_bool.dart';
import '../../../../shared/widgets/ui/inputs/app_input_color/app_input_color.dart';
import '../../../../shared/widgets/ui/inputs/app_input_color/color_circle.dart';
import '../../../../shared/widgets/ui/inputs/app_input_number.dart';
import '../../../../shared/widgets/ui/inputs/app_input_option.dart';
import '../../../settings_window/presentation/widgets/setting.dart';
import '../../../settings_window/presentation/widgets/setting_section.dart';
import '../../settings/presenter_settings.dart';
import '../models/gradient_preset.dart';

class PresenterSettingsPage extends StatelessWidget {
  const PresenterSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit<PresenterSettings>>();

    return BlocBuilder<SettingsCubit<PresenterSettings>, PresenterSettings>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: SettingSection(
            children: [
              Setting(
                label: 'Auto number titles',
                description:
                    'Automatically adds sequential numbers (1, 2, 3...) to the front of your slide titles.',
                child: AppInputBool(
                  value: state.enableAutoNumbering,
                  onChanged: (val) =>
                      cubit.update((p) => p.copyWith(enableAutoNumbering: val)),
                ),
              ),
              Setting(
                label: 'Start numbering from slide',
                child: AppInputNumber(
                  min: 1,
                  onSubmitted: (n) {
                    cubit.update(
                        (p) => p.copyWith(startNumberingFrom: n.toInt()));
                  },
                  value: state.startNumberingFrom,
                ),
              ),
              Setting(
                label: 'Use gradient background',
                child: AppInputBool(
                  value: state.useGradientBackground,
                  onChanged: (val) => cubit
                      .update((p) => p.copyWith(useGradientBackground: val)),
                ),
              ),
              Setting(
                label: 'Background color',
                child: state.useGradientBackground
                    ? _GradientSelector(
                        presets: GradientPreset.values,
                        initialSelected: state.gradientBackground,
                        onChanged: (selected) => cubit.update(
                            (p) => p.copyWith(gradientBackground: selected)),
                      )
                    // ? Setting(
                    //     label: 'Background color',
                    //     child: AppInputOption<GradientPreset>(
                    //       onChanged: (fw) {},
                    //       items: GradientPreset.values
                    //           .map(
                    //               (g) => AppDropdownItem(value: g, label: g.name))
                    //           .toList(),
                    //     ))
                    : AppInputColor(
                        onColorChanged: (c) =>
                            cubit.update((p) => p.copyWith(backgroundColor: c)),
                        color: state.backgroundColor,
                      ),
              ),
              Setting(
                  label: 'Text color',
                  child: AppInputColor(
                    onColorChanged: (c) =>
                        cubit.update((p) => p.copyWith(textColor: c)),
                    color: state.textColor,
                  )),
              Setting(
                  label: 'Title font weight',
                  child: AppInputOption(
                    onChanged: (fw) {},
                    items: [],
                  )),
              Setting(
                  label: 'Subtitle font weight',
                  child: AppInputOption(
                    onChanged: (fw) {},
                    items: [],
                  )),
              Setting(
                label: 'Size factor',
                description:
                    'How much space in the screen does the Presenter take when it is visible',
                child: AppInputNumber(
                  suffixIcon: LucideIcons.percent,
                  min: 10,
                  max: 90,
                  decimal: false,
                  onSubmitted: (n) {
                    cubit.update((p) => p.copyWith(sizeFactor: (n / 100)));
                  },
                  value: (state.sizeFactor * 100).round(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GradientSelector extends StatefulWidget {
  const _GradientSelector({
    required this.onChanged,
    required this.presets,
    this.initialSelected = 'blue',
  });

  final Function(String) onChanged;
  final List<GradientPreset> presets;
  final String initialSelected;

  @override
  State<_GradientSelector> createState() => _GradientSelectorState();
}

class _GradientSelectorState extends State<_GradientSelector> {
  late String selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      alignment: WrapAlignment.end,
      children: widget.presets.map((p) {
        final isSelected = selected == p.name.toLowerCase();

        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () {
              setState(() => selected = p.name.toLowerCase());
              widget.onChanged(selected);
            },
            child: ColorCircle(
              gradient: p.gradient,
              size: 28,
            ),
          ),
        );
      }).toList(),
    );
  }
}
