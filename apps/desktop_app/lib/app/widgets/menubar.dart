import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../features/settings_window/presentation/models/settings_route.dart';
import '../../features/settings_window/presentation/pages/settings_window.dart';
import '../../features/window_stack_manager/presentation/state/window_stack_manager_bloc.dart';
import 'toolbar.dart';

class MyMenuBar extends StatelessWidget {
  const MyMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(children: [
        IconButton(
          onPressed: () {
            context.read<WindowStackManagerBloc>().add(
                  WindowStackManagerOpen.selfManaged(
                    widget: SettingsWindow(
                      initialPage: SettingsPage.globalAppearance,
                    ),
                  ),
                );
          },
          icon: const Icon(LucideIcons.settings),
        ),
        const ToolbarButton(),
      ]),
    );
  }
}
