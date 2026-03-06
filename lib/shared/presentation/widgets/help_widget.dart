import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/shortcuts/presentation/widget/keycap.dart';
import 'package:open_scripture/shared/presentation/widgets/custom_window_wrapper.dart';

import '../../../features/shortcuts/domain/app_command.dart';
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
          context
              .read<WindowStackManagerBloc>()
              .add(WindowStackManagerOpen(HelpWindow(
            onClose: () {
              context
                  .read<WindowStackManagerBloc>()
                  .add(WindowStackManagerClose());
            },
          )));
        },
        icon: Icon(Icons.help_outline_rounded));
  }
}

const double shortcutWidth = 200;

class HelpWindow extends StatelessWidget {
  const HelpWindow({super.key, this.onClose});

  final Function()? onClose;

  @override
  Widget build(BuildContext context) {
    return CustomWindowWrapper(
      title: 'Quick Overview',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                    'Use these main shortcuts to quickly navigate and execute actions:'),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('-  Quickly focus searchbar'),
                    SizedBox(
                      width: shortcutWidth,
                      child: ShortcutView(
                          activator:
                              appCommandShortcuts[AppCommand.focusSearch]),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('-  Move verse'),
                    SizedBox(
                      width: shortcutWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 2,
                        children: [
                          ShortcutView(
                              activator:
                                  appCommandShortcuts[AppCommand.prevVerse]),
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
                    const Text('-  Change display mode'),
                    SizedBox(
                      width: shortcutWidth,
                      child: ShortcutView(
                          activator: appCommandShortcuts[
                              AppCommand.switchDisplayMode]),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('-  Change bible'),
                    SizedBox(
                      width: shortcutWidth,
                      child: ShortcutView(
                          activator:
                              appCommandShortcuts[AppCommand.changeBible]),
                    )
                  ],
                ),
                const SizedBox(height: 24),
                const Text('Open [Settings > Shortcuts] for more. Nice 👍'),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
