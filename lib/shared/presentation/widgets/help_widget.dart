import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/shortcuts/domain/app_command.dart';
import '../../../features/shortcuts/presentation/widget/parts/shortcut_view.dart';
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
              .add(WindowStackManagerOpen(HelpWidget(
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

class HelpWidget extends StatelessWidget {
  const HelpWidget({super.key, this.onClose});

  final Function()? onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 450,
      height: 315,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              SizedBox(width: 16),
              Expanded(
                  child: const Text('Quick overview',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 18))),
              IconButton(
                  onPressed: () {
                    onClose?.call();
                  },
                  icon: Icon(Icons.close)),
            ],
          ),
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
                    const Text('-  Go to next verse'),
                    SizedBox(
                      width: shortcutWidth,
                      child: ShortcutView(
                          activator: appCommandShortcuts[AppCommand.nextVerse]),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('-  Go to previous verse'),
                    SizedBox(
                      width: shortcutWidth,
                      child: ShortcutView(
                          activator: appCommandShortcuts[AppCommand.prevVerse]),
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
