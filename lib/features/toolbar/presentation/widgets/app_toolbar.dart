import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../settings_window/presentation/widgets/settings_window.dart';
import '../../../window_stack_manager/presentation/bloc/window_stack_manager_bloc.dart';
import 'toolbar.dart';

class AppToolbar extends StatelessWidget {
  const AppToolbar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Toolbar(
      options: [
        ToolbarOption(
          'Bible',
          onTap: () {
            context.read<WindowStackManagerBloc>().add(
                  WindowStackManagerOpen(
                    SettingsWindow(
                      initialRoute: SettingsSection.bibleManager,
                      onClose: () {
                        context
                            .read<WindowStackManagerBloc>()
                            .add(WindowStackManagerClose());
                      },
                    ),
                  ),
                );
          },
        ),
        const ToolbarOption('Options'),
        const ToolbarOption('Tools'),
        ToolbarOption(
          'Help',
          onTap: () {
            context.read<WindowStackManagerBloc>().add(
                  WindowStackManagerOpen(
                    SettingsWindow(
                      initialRoute: SettingsSection.about,
                      onClose: () {
                        context
                            .read<WindowStackManagerBloc>()
                            .add(WindowStackManagerClose());
                      },
                    ),
                  ),
                );
          },
        ),
      ],
      child: child,
    );
  }
}
