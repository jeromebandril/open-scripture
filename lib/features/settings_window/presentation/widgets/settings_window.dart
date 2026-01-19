import 'package:flutter/material.dart';
import 'package:the_smyrna_bible_v2/features/bible_installer_manager/presentation/widgets/translation_manager.dart';
import 'package:the_smyrna_bible_v2/features/customizer/presentation/widgets/customizer_screen.dart';
import 'package:the_smyrna_bible_v2/features/keybindings/presentation/pages/keybindings_screen.dart';

import 'sidebar_navigator.dart';
import 'unknown.dart';

enum SettingsSection { appearance, bibleManager, shortcuts, about }

String routeFor(SettingsSection s) => switch (s) {
      SettingsSection.appearance => '/appearance',
      SettingsSection.bibleManager => '/biblemanager',
      SettingsSection.shortcuts => '/shortcuts',
      SettingsSection.about => '/about',
    };

final Map<String, SettingsRoute> settingsRoutes = {
  '/appearance': SettingsRoute(
      icon: Icons.palette_rounded,
      name: 'Appearance',
      builder: (_) => const CustomizerScreen()),
  '/biblemanager': SettingsRoute(
      icon: Icons.menu_book_sharp,
      name: 'Bible Manager',
      builder: (_) => const BibleManagerWidget()),
  '/shortcuts': SettingsRoute(
      icon: Icons.keyboard,
      name: 'Shortcuts',
      builder: (_) => const KeybindingsScreen()),
  '/about': SettingsRoute(
      icon: Icons.info_outline,
      name: 'About',
      builder: (_) => const Text('about')),
};

class SettingsRoute {
  final IconData? icon;
  final String name;
  final WidgetBuilder builder;

  SettingsRoute({
    this.icon,
    required this.name,
    required this.builder,
  });
}

class SettingsWindow extends StatefulWidget {
  final SettingsSection initialRoute;
  final Function()? onClose;

  const SettingsWindow({
    required this.initialRoute,
    this.onClose,
    super.key,
  });

  @override
  State<SettingsWindow> createState() => _SettingsWindowState();
}

class _SettingsWindowState extends State<SettingsWindow> {
  final _navKey = GlobalKey<NavigatorState>();

  late String _selectedRoute;

  @override
  void initState() {
    super.initState();
    _selectedRoute = routeFor(widget.initialRoute);
  }

  void _goTo(String route) {
    setState(() => _selectedRoute = route);

    // For "settings sections", replacement is usually better than stacking.
    _navKey.currentState?.pushReplacementNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 1270,
        maxHeight: 800,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Row(
        children: [
          SidebarNavigator(
            width: 100,
            selectedRoute: _selectedRoute,
            onSelectRoute: _goTo,
          ),
          Expanded(
            flex: 4,
            child: _SettingRouteLayout(
              onClose: widget.onClose,
              child: Navigator(
                key: _navKey,
                initialRoute: routeFor(widget.initialRoute),
                onGenerateRoute: (routeSettings) {
                  final name = routeSettings.name ?? '/';
                  final setting = settingsRoutes[name];

                  if (setting?.builder == null) {
                    return MaterialPageRoute(
                      builder: (_) => const UnknownSettingsRoute(),
                      settings: routeSettings,
                    );
                  }

                  return PageRouteBuilder(
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                    settings: routeSettings,
                    pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation) =>
                        setting!.builder(context),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingRouteLayout extends StatelessWidget {
  final Widget child;
  final Function()? onClose;

  const _SettingRouteLayout({
    required this.child,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _HeaderSettings(
          height: 40,
          onClose: () {
            if (onClose != null) onClose!();
          },
        ),
        SizedBox(height: 16),
        Expanded(child: child),
      ],
    );
  }
}

class _HeaderSettings extends StatelessWidget {
  final double height;
  final Function()? onClose;

  const _HeaderSettings({
    required this.height,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      height: height,
      child: IconButton(
          onPressed: () {
            if (onClose != null) onClose!();
          },
          icon: const Icon(Icons.close)),
    );
  }
}
