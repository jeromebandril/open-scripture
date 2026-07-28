import 'package:flutter/material.dart';

import '../../../bible_importer/presentation/pages/importer_page.dart';
import '../../../bible_display/settings/presentation/pages/bible_view_settings_page.dart';
import '../../../../app/settings/presentation/pages/global_customizer_screen.dart';
import '../../../my_library/presentation/pages/library_manager_page.dart';
import '../../../obs_live_overlay/presentation/pages/obs_live_overlay_page.dart';
import '../../../remote_controller/presentation/pages/remote_controller_page.dart';
import '../../../shortcuts/presentation/pages/shortcuts_screen.dart';
import '../pages/about_setting_page.dart';

enum SettingsGroup {
  appearance('Appearance'),
  bibleManager('Bible Manager'),
  tools('Tools'),
  others('Others');

  final String title;
  const SettingsGroup(this.title);
}

enum SettingsPage {
  globalAppearance(
    route: '/appearance/global',
    name: 'Global',
    icon: Icons.settings_rounded,
    group: SettingsGroup.appearance,
  ),
  bibleViewer(
    route: '/appearance/bibleview',
    name: 'Bible viewer',
    icon: Icons.palette_rounded,
    group: SettingsGroup.appearance,
  ),
  library(
    route: '/biblemanager/library',
    name: 'My Library',
    icon: Icons.local_library_rounded,
    group: SettingsGroup.bibleManager,
  ),
  importer(
    route: '/biblemanager/importer',
    name: 'Import',
    icon: Icons.file_upload_outlined,
    group: SettingsGroup.bibleManager,
  ),
  obsLiveOverlay(
    route: '/obsliveoverlay',
    name: 'OBS Live Overlay',
    icon: Icons.live_tv_rounded,
    group: SettingsGroup.tools,
  ),
  remoteController(
    route: '/remotecontroller',
    name: 'Remote Controller (beta)',
    icon: Icons.stay_current_portrait_rounded,
    group: SettingsGroup.tools,
  ),
  shortcuts(
    route: '/shortcuts',
    name: 'Shortcuts',
    icon: Icons.keyboard,
    group: SettingsGroup.others,
  ),
  about(
    route: '/about',
    name: 'About',
    icon: Icons.info_outline,
    group: SettingsGroup.others,
  );

  final String route;
  final String name;
  final IconData icon;
  final SettingsGroup group;

  const SettingsPage({
    required this.route,
    required this.name,
    required this.icon,
    required this.group,
  });

  bool get isSupportedOnPlatform {
    // if (kIsWeb) {
    //   return this != SettingsPage.obsLiveOverlay &&
    //       this != SettingsPage.remoteController;
    // }
    return true;
  }

  static SettingsPage? fromRoutePath(String path) {
    for (final page in values) {
      if (page.route == path) return page;
    }
    return null;
  }
}

final Map<SettingsPage, WidgetBuilder> settingsBuilders = {
  SettingsPage.globalAppearance: (_) => const GlobalCustomizerScreen(),
  SettingsPage.bibleViewer: (_) => const BibleViewSettingsPage(),
  SettingsPage.library: (_) => const LibrariesPage(),
  SettingsPage.importer: (_) => const ImporterPage(),
  SettingsPage.obsLiveOverlay: (_) => const ObsLiveOverlayPage(),
  SettingsPage.remoteController: (_) => const RemoteControllerPage(),
  SettingsPage.shortcuts: (_) => const ShortcutsScreen(),
  SettingsPage.about: (_) => const AboutSettingsPage(),
};

/// Generate the Sidebar Menu dynamically
Map<SettingsGroup, List<SettingsPage>> get sidebarNavigation {
  final Map<SettingsGroup, List<SettingsPage>> menu = {};

  for (final page in SettingsPage.values) {
    if (!page.isSupportedOnPlatform) continue;
    menu.putIfAbsent(page.group, () => []).add(page);
  }

  return menu;
}
