import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/tokens.dart';
import '../../../window_stack_manager/presentation/bloc/window_stack_manager_bloc.dart';
import '../models/settings_route.dart';
import 'parts/sidebar_navigator.dart';

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
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.lg)),
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
              onClose: () => context
                  .read<WindowStackManagerBloc>()
                  .add(WindowStackManagerClose()),
              child: Navigator(
                key: _navKey,
                initialRoute: routeFor(widget.initialRoute),
                onGenerateRoute: (routeSettings) {
                  final name = routeSettings.name ?? '/';
                  final setting = settingsRoutes[name];

                  if (setting?.builder == null) {
                    return MaterialPageRoute(
                      builder: (_) => const Center(child: Text('Uknown')),
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
