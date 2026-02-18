import 'package:flutter/material.dart';
import 'package:open_scripture/features/bible_importer/presentation/page/importer_page.dart';
import 'package:open_scripture/features/customizer/presentation/pages/bible_pane_customizer_screen.dart';
import 'package:open_scripture/features/customizer/presentation/pages/global_customizer_screen.dart';
import 'package:open_scripture/features/obs_live_overlay/presentation/page/obs_live_overlay_page.dart';
import 'package:open_scripture/features/settings_window/presentation/pages/about_setting_page.dart';

import '../../../bible_installer_manager/presentation/pages/translation_manager.dart';
import '../../../shortcuts/presentation/pages/shortcuts_screen.dart';

enum SettingsSection { appearance, bibleManager, shortcuts, about }

String routeFor(SettingsSection s) => switch (s) {
      SettingsSection.appearance => '/appearance/global',
      SettingsSection.bibleManager => '/biblemanager/repo',
      SettingsSection.shortcuts => '/shortcuts',
      SettingsSection.about => '/about',
    };

final Map<String, SettingsRoute> settingsRoutes = {
  '/appearance/global': SettingsRoute(
      icon: Icons.settings_rounded,
      name: 'Global',
      builder: (_) => const GlobalCustomizerScreen()),
  '/appearance/bibleview': SettingsRoute(
      icon: Icons.palette_rounded,
      name: 'Bible viewer',
      builder: (_) => const BiblePaneCustomizerScreen()),
  '/biblemanager/repo': SettingsRoute(
      icon: Icons.menu_book_sharp,
      name: 'Download & Install',
      builder: (_) => const BibleManagerWidget()),
  '/biblemanager/importer': SettingsRoute(
      icon: Icons.file_download_outlined,
      name: 'Import',
      builder: (_) => const ImporterPage()),
  '/obsliveoverlay': SettingsRoute(
      icon: Icons.live_tv_rounded,
      name: 'OBS Live Overlay (beta)',
      builder: (_) => const ObsLiveOverlayPage()),
  '/shortcuts': SettingsRoute(
      icon: Icons.keyboard,
      name: 'Shortcuts',
      builder: (_) => const ShortcutsScreen()),
  '/about': SettingsRoute(
      icon: Icons.info_outline,
      name: 'About',
      builder: (_) => const AboutSettingsPage()),
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

String parentSegment(String route) {
  final segs = route.split('/').where((s) => s.isNotEmpty).toList();

  if (segs.length == 1) return 'Others';

  return segs.isEmpty ? '' : segs.first;
}

Map<String, List<MapEntry<String, SettingsRoute>>> groupedSettingsRoutes(
  Map<String, SettingsRoute> routes,
) {
  final entries = routes.entries.toList();

  // entries.sort((a, b) {
  //   final pa = parentSegment(a.key);
  //   final pb = parentSegment(b.key);
  //   final c1 = pa.compareTo(pb);
  //   if (c1 != 0) return c1;
  //   return a.value.name.compareTo(b.value.name);
  // });

  final Map<String, List<MapEntry<String, SettingsRoute>>> groups = {};
  for (final e in entries) {
    final p = parentSegment(e.key);
    groups.putIfAbsent(p, () => []).add(e);
  }
  return groups;
}
