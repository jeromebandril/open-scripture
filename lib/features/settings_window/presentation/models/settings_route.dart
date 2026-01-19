import 'package:flutter/material.dart';
import 'package:the_smyrna_bible_v2/features/settings_window/presentation/pages/about_setting_page.dart';

import '../../../bible_installer_manager/presentation/pages/translation_manager.dart';
import '../../../customizer/presentation/pages/customizer_screen.dart';
import '../../../keybindings/presentation/pages/keybindings_screen.dart';

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
