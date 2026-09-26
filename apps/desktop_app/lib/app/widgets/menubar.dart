import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../features/settings_window/presentation/models/settings_route.dart';
import '../../features/settings_window/presentation/pages/settings_window.dart';
import '../../features/simple_presenter/presentation/pages/presenter_setup_page.dart';
import '../extensions/build_context_extensions.dart';
import 'toolbar.dart';

class MyMenuBar extends StatelessWidget {
  const MyMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(children: [
        IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: () {
            context.pushWindow(
              builder: (_) => SettingsWindow(
                initialPage: SettingsPage.globalAppearance,
              ),
            );
          },
          icon: const Icon(LucideIcons.settings),
        ),
        const ToolbarButton(),
        IconButton(
            onPressed: () {
              context.pushStandardWindow(
                builder: (_) => const PresenterSetupPage(),
                title: 'Presenter setup',
                maxSize: Size(800, 700),
              );
            },
            icon: const Icon(LucideIcons.rectangleCircle)),
      ]),
    );
  }
}
