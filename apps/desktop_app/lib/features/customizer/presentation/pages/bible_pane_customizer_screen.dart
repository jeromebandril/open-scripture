import 'package:flutter/material.dart';
import 'package:open_scripture/features/customizer/presentation/pages/bible_pane_general_customizer_screen.dart';
import 'package:open_scripture/features/customizer/presentation/pages/bible_view_list_customizer_screen.dart';
import 'package:open_scripture/features/customizer/presentation/pages/bible_view_presentation_customizer_screen.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_subpage_navigator.dart';

class BiblePaneCustomizerScreen extends StatefulWidget {
  const BiblePaneCustomizerScreen({super.key});

  @override
  State<BiblePaneCustomizerScreen> createState() =>
      _BiblePaneCustomizerScreenState();
}

class _BiblePaneCustomizerScreenState extends State<BiblePaneCustomizerScreen> {
  int _index = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const BiblePaneGeneralCustomizerScreen(),
      const BibleViewListCustomizerScreen(),
      const BibleViewPresentationCustomizerScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(42, 0, 42, 42),
      child: Column(
        spacing: 8,
        children: [
          SettingSubpageNavigator(
            selectedId: _index,
            data: [
              SettingSubpageNavigatorData(
                id: 0,
                onSelect: (id) => setState(() {
                  _index = id;
                }),
                icon: Icon(Icons.color_lens_rounded),
                title: 'General',
              ),
              SettingSubpageNavigatorData(
                id: 1,
                onSelect: (id) => setState(() {
                  _index = id;
                }),
                icon: const Icon(Icons.list),
                title: 'List view',
              ),
              SettingSubpageNavigatorData(
                id: 2,
                onSelect: (id) => setState(() {
                  _index = id;
                }),
                icon: const Icon(Icons.screenshot_monitor_rounded),
                title: 'Presentation view',
              ),
            ],
          ),
          Expanded(
            child: IndexedStack(
              index: _index,
              children: _pages,
            ),
          ),
        ],
      ),
    );
  }
}
