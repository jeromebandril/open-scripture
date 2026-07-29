import 'package:flutter/material.dart';

import '../../../../../shared/widgets/ui/b_container_tab_bar.dart';
import 'bible_view_general_settings_tab.dart';
import 'bible_view_list_settings_tab.dart';
import 'bible_view_presentation_settings_tab.dart';
import 'bible_view_prose_settings_tab.dart';

class BibleViewSettingsPage extends StatefulWidget {
  const BibleViewSettingsPage({super.key});

  @override
  State<BibleViewSettingsPage> createState() => _BibleViewSettingsPageState();
}

class _BibleViewSettingsPageState extends State<BibleViewSettingsPage> {
  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      const BibleViewGeneralSettingsTab(),
      const BibleViewListSettingsTab(),
      const BibleViewPresentationSettingsTab(),
      const BibleViewProseSettingsTab(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(42, 0, 42, 42),
      child: BContainerTabBar(
        tabs: ['General', 'List View', 'Presentation View', 'Prose View'],
        views: _tabs,
      ),
    );
  }
}
