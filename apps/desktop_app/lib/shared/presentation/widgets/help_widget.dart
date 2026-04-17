import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/shortcuts/presentation/widget/keycap.dart';

import '../../../features/shortcuts/domain/models/app_command.dart';
import '../../../features/shortcuts/presentation/models/app_command_shortcuts.dart';
import '../../../features/shortcuts/presentation/widget/shortcut_view.dart';
import '../../../features/window_stack_manager/presentation/bloc/window_stack_manager_bloc.dart';

class HelpTriggerBtn extends StatelessWidget {
  const HelpTriggerBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        tooltip: 'Help',
        onPressed: () {
          context.read<WindowStackManagerBloc>().add(
                WindowStackManagerOpen(
                  title: 'Quick Overview',
                  widget: HelpScreen(
                    onClose: () {
                      context
                          .read<WindowStackManagerBloc>()
                          .add(WindowStackManagerClose());
                    },
                  ),
                  size: Size(530, 615),
                ),
              );
        },
        icon: Icon(Icons.help_outline_rounded));
  }
}

const double shortcutWidth = 200;

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key, this.onClose});

  final Function()? onClose;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1. Shortcuts',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              Text(
                  'Use these essential shortcuts (go to <shortcuts> for more) to quickly navigate and execute actions:'),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('  • Quickly focus searchbar'),
              SizedBox(
                width: shortcutWidth,
                child: ShortcutView(
                    activator: appCommandShortcuts[AppCommand.focusSearch]),
              )
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('  •  Move verse'),
              SizedBox(
                width: shortcutWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 2,
                  children: [
                    ShortcutView(
                        activator: appCommandShortcuts[AppCommand.prevVerse]),
                    Text(''),
                    Keycap('→')
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('  •  Change display mode'),
              SizedBox(
                width: shortcutWidth,
                child: ShortcutView(
                    activator:
                        appCommandShortcuts[AppCommand.switchDisplayMode]),
              )
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('  •  Change bible'),
              SizedBox(
                width: shortcutWidth,
                child: ShortcutView(
                    activator: appCommandShortcuts[AppCommand.changeBible]),
              )
            ],
          ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '2. How to Search Query',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const Text('The standard search query format is: '),
              const SizedBox(height: 4),
              const Row(
                children: [
                  Keycap('book'),
                  Text('<space>'),
                  Keycap('chapter'),
                  Text('<separator>'),
                  Keycap('verse')
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                  'For example: type  "John  3:16"  and it will display the whole chapter 3 by default, and highlight the verse'),
              const SizedBox(height: 16),
              const Text('Additional info: '),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("• "),
                        Expanded(
                            child: Text(
                                "If verse number is omitted, it defaults to verse 1")),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("• "),
                        Expanded(
                            child: Text(
                                "To jump to verse (same book and chapter), just type the verse number")),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("• "),
                        Expanded(
                          child: Wrap(
                            spacing: 4,
                            children: [
                              Text(
                                  "You can use any <separator> from these options: "),
                              Keycap(':'),
                              Keycap('.'),
                              Keycap('<space>'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("• "),
                        Expanded(
                            child: Wrap(
                          spacing: 4,
                          children: [
                            Text(
                                "You can pre-select a range of verses by typing after verse: "),
                            Keycap('-'),
                            Keycap('verse end'),
                            Text('like this:  "John 3:16-20"')
                          ],
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
