import 'package:flutter/material.dart';

import '../../../features/keybindings/domain/app_command.dart';
import '../../../features/keybindings/presentation/widget/parts/shortcut_view.dart';

class HelpWidget extends StatelessWidget {
  const HelpWidget({super.key, this.onClose});

  final Function()? onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 275,
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
                  child: Text('Yo, Need Help?',
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
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Stuck in this view? Be ye not worried bretheren:'),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('-  Quickly focus searchbar'),
                    ShortcutView(
                        activator: appCommandShortcuts[AppCommand.focusSearch])
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('-  Toggle fullscren'),
                    ShortcutView(
                        activator:
                            appCommandShortcuts[AppCommand.toggleFullscreen])
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('-  Toggle toolbar'),
                    ShortcutView(
                        activator:
                            appCommandShortcuts[AppCommand.toggleToolbar])
                  ],
                ),
                SizedBox(height: 24),
                Text('Your welcome my friend 👍')
              ],
            ),
          )),
        ],
      ),
    );
  }
}
