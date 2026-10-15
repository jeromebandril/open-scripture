import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/extensions/build_context_extensions.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../../../../../shared/presentation/widgets/ui/inputs/app_input_color/app_input_color.dart';
import '../../../../../shared/presentation/widgets/ui/inputs/app_input_text.dart';
import '../../../../settings_window/presentation/widgets/setting_option.dart';
import '../../../../settings_window/presentation/widgets/setting_section.dart';
import '../../../settings/presentation/widgets/bible_view_settings_provider.dart';
import '../../domain/entities/bible_view_colorscheme.dart';
import '../cubit/colorscheme_cubit.dart';

class ColorschemeEditor extends StatefulWidget {
  /// Pass initial draft, otherwise get currect active colorscheme
  final BibleViewColorscheme? initialDraft;

  const ColorschemeEditor({super.key, this.initialDraft});

  @override
  State<ColorschemeEditor> createState() => _ColorschemeEditorState();
}

class _ColorschemeEditorState extends State<ColorschemeEditor> {
  late BibleViewColorscheme draft;
  late final bool isEditMode;

  @override
  initState() {
    super.initState();
    isEditMode = widget.initialDraft != null;
    draft = isEditMode
        ? widget.initialDraft!
        : BibleViewSettingsScope.readColorscheme(context).asNewCustom();
  }

  void _saveDraft() {
    context.read<ColorschemesCubit>().save(draft);
    context.closeWindow();
  }

  void _updateDraft(BibleViewColorscheme update) => setState(() {
        draft = update;
      });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.lg,
      children: [
        Expanded(
          flex: 10,
          child: Placeholder(
            child: Center(
              child: Text(
                'Here preview',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Column(
            spacing: AppSpacing.sm,
            children: [
              _ColorSettings(
                draft: draft,
                onDraftUpdated: _updateDraft,
              ),
              _FooterActions(
                isEditMode: isEditMode,
                onConfirm: _saveDraft,
              )
            ],
          ),
        ),
      ],
    );
  }
}

class _ColorSettings extends StatelessWidget {
  final BibleViewColorscheme draft;
  final ValueChanged<BibleViewColorscheme> onDraftUpdated;

  const _ColorSettings({required this.draft, required this.onDraftUpdated});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SettingSection.single(
              child: SettingOption(
                label: 'Name',
                description: 'A unique name to recognize the colorscheme',
                child: AppInputText(
                  value: draft.label,
                  onChanged: (val) =>
                      onDraftUpdated(draft.copyWith(label: val)),
                ),
              ),
            ),
            SettingSection(
              title: 'Main colors',
              children: [
                SettingOption(
                    label: 'Background color',
                    description: 'Set color for the background',
                    child: AppInputColor(
                      onColorChanged: (c) {
                        onDraftUpdated(draft.copyWith(backgroundColor: c));
                      },
                      color: draft.backgroundColor,
                    )),
                SettingOption(
                  label: 'Verse color',
                  description: 'Set color for the verse text',
                  child: AppInputColor(
                    onColorChanged: (c) {
                      onDraftUpdated(draft.copyWith(verseColor: c));
                    },
                    color: draft.verseColor,
                  ),
                ),
                SettingOption(
                  label: 'Reference color',
                  description: 'Set color for the verse reference (unselected)',
                  child: AppInputColor(
                      onColorChanged: (c) {
                        onDraftUpdated(draft.copyWith(refColor: c));
                      },
                      color: draft.refColor),
                ),
                SettingOption(
                  label: 'Selected reference color',
                  description: 'Set color for the verse reference (selected)',
                  settingWidth: 250,
                  child: AppInputColor(
                    onColorChanged: (c) {
                      onDraftUpdated(draft.copyWith(selectedRefColor: c));
                    },
                    color: draft.selectedRefColor,
                  ),
                ),
              ],
            ),
            SettingSection(
              title: 'Render colors',
              children: [
                SettingOption(
                  label: 'Pericope color',
                  description: 'Set color for the pericope heading',
                  child: AppInputColor(
                    onColorChanged: (c) {
                      onDraftUpdated(draft.copyWith(pericopeColor: c));
                    },
                    color: draft.pericopeColor,
                  ),
                ),
                SettingOption(
                  label: 'Quote color',
                  description:
                      'Set color for the verse quotes (usually "word of jesus")',
                  child: AppInputColor(
                      onColorChanged: (c) {
                        onDraftUpdated(draft.copyWith(quoteColor: c));
                      },
                      color: draft.quoteColor),
                ),
                SettingOption(
                  label: 'Add color',
                  description: 'Set color for added words',
                  child: AppInputColor(
                    onColorChanged: (c) {
                      onDraftUpdated(draft.copyWith(addColor: c));
                    },
                    color: draft.addColor,
                  ),
                ),
              ],
            ),
            SettingSection(
              title: 'Others',
              children: [
                SettingOption(
                  label: 'Verse divider color',
                  description: 'Set color for verse divider',
                  child: AppInputColor(
                    onColorChanged: (c) {
                      onDraftUpdated(draft.copyWith(verseDividerColor: c));
                    },
                    color: draft.verseDividerColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterActions extends StatelessWidget {
  final VoidCallback onConfirm;
  final bool isEditMode;

  const _FooterActions({required this.onConfirm, required this.isEditMode});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      spacing: AppSpacing.sm,
      children: [
        OutlinedButton(
          onPressed: () => context.closeWindow(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          child: isEditMode ? const Text('Save edit') : const Text('Save'),
        )
      ],
    );
  }
}
