import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../shared/design_system/design_system.dart';
import '../../../../shortcuts/domain/models/app_command.dart';
import '../../../../shortcuts/presentation/models/app_command_shortcuts.dart';
import '../../../../shortcuts/presentation/widgets/shortcut_view.dart';
import '../state/bible_pane_bloc.dart';

const _welcomeVerses = [
  (
    reference: '1 Corinthians 14:40',
    text: 'Let all things be done decently and in order.',
  ),
  (
    reference: 'Psalm 119:105',
    text: 'Thy word is a lamp unto my feet, and a light unto my path.',
  ),
  (
    reference: 'Colossians 3:16',
    text: 'Let the word of Christ dwell in you richly in all wisdom.',
  ),
  (
    reference: 'Hebrews 4:12',
    text:
        'For the word of God is quick, and powerful, and sharper than any twoedged sword.',
  ),
  (
    reference: 'Romans 10:17',
    text: 'So then faith cometh by hearing, and hearing by the word of God.',
  ),
  (
    reference: 'Psalm 96:9',
    text: 'O worship the LORD in the beauty of holiness.',
  ),
  (
    reference: 'Nehemiah 8:8',
    text: 'So they read in the book in the law of God distinctly.',
  ),
  (
    reference: '2 Timothy 3:16',
    text: 'All scripture is given by inspiration of God.',
  ),
];

class InitalEmptyContentScreen extends StatefulWidget {
  const InitalEmptyContentScreen({super.key});

  @override
  State<InitalEmptyContentScreen> createState() =>
      _InitalEmptyContentScreenState();
}

class _InitalEmptyContentScreenState extends State<InitalEmptyContentScreen> {
  late final verse;

  @override
  void initState() {
    super.initState();
    verse = _welcomeVerses[Random().nextInt(_welcomeVerses.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 300),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: AppSpacing.sm,
          children: [
            Text(
              'Ready',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            BlocBuilder<BiblePaneBloc, BiblePaneState>(
              builder: (context, state) {
                final openBibles =
                    state.openedBiblesIds.map((ob) => ob.externalId);
                return Text(
                  openBibles.join(' | '),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                );
              },
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              '"${verse.text}" - ${verse.reference.replaceAll(' ', '\u00A0')}',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.sm),
            _Control(
              command: AppCommand.focusSearch,
              label: 'Search reference',
              icon: LucideIcons.search,
            ),
            _Control(
              command: AppCommand.nextVerse,
              label: 'Select next verse',
              icon: LucideIcons.arrowRight,
            ),
            _Control(
              command: AppCommand.toggleFullscreen,
              label: 'Toggle Fullscreen',
              icon: LucideIcons.maximize2,
            ),
            _Control(
              command: AppCommand.toggleToolbar,
              label: 'Toggle topbar',
              icon: LucideIcons.panelTop,
            ),
            _Control(
              command: AppCommand.changeBible,
              label: 'Change bible',
              icon: LucideIcons.bookOpen,
            ),
            _Control(
              command: AppCommand.switchDisplayMode,
              label: 'Switch display mode',
              icon: LucideIcons.monitor,
            ),
            _Control(
              command: AppCommand.addPane,
              label: 'Add split screen',
              icon: LucideIcons.squareSplitHorizontal,
            ),
          ],
        ),
      ),
    );
  }
}

class _Control extends StatelessWidget {
  const _Control({
    required this.command,
    required this.label,
    required this.icon,
  });

  final AppCommand command;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: AppSpacing.sm),
        Text(label),
        const Spacer(),
        ShortcutView(activator: appCommandShortcuts[command], fontSize: 11),
      ],
    );
  }
}
