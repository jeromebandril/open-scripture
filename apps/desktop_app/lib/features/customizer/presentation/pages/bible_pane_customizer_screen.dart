import 'package:flutter/material.dart';
import 'package:open_scripture/features/customizer/presentation/pages/bible_pane_general_customizer_screen.dart';
import 'package:open_scripture/features/customizer/presentation/pages/bible_view_list_customizer_screen.dart';
import 'package:open_scripture/features/customizer/presentation/pages/bible_view_presentation_customizer_screen.dart';

import '../../../bible_display/bible_pane/domain/display_mode.dart';
import '../../../settings_window/presentation/widgets/setting_section.dart';
import '../../../settings_window/presentation/widgets/setting_subpage_navigator.dart';
import '../widgets/bible_pane_preview.dart';

class BiblePaneCustomizerScreen extends StatefulWidget {
  const BiblePaneCustomizerScreen({super.key});

  @override
  State<BiblePaneCustomizerScreen> createState() =>
      _BiblePaneCustomizerScreenState();
}

class _BiblePaneCustomizerScreenState extends State<BiblePaneCustomizerScreen> {
  int _index = 0;
  late final List<Widget> _pages;
  DisplayMode _previewMode = DisplayMode.list;

  @override
  void initState() {
    super.initState();
    _pages = [
      const BiblePaneGeneralCustomizerScreen(),
      const BibleViewListCustomizerScreen(),
      const BibleViewPresentationCustomizerScreen(),
    ];
  }

  String _previewTitle() {
    switch (_index) {
      case 0:
        return 'General';
      case 1:
        return 'List';
      case 2:
        return 'Presentation';
      default:
        return '';
    }
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
                  _previewMode = DisplayMode.list;
                }),
                icon: Icon(Icons.color_lens_rounded),
                title: 'General',
              ),
              SettingSubpageNavigatorData(
                id: 1,
                onSelect: (id) => setState(() {
                  _index = id;
                  _previewMode = DisplayMode.list;
                }),
                icon: const Icon(Icons.list),
                title: 'List view',
              ),
              SettingSubpageNavigatorData(
                id: 2,
                onSelect: (id) => setState(() {
                  _index = id;
                  _previewMode = DisplayMode.presentation;
                }),
                icon: const Icon(Icons.screenshot_monitor_rounded),
                title: 'Presentation view',
              ),
            ],
          ),
          Expanded(
            child: Row(spacing: 8, children: [
              Expanded(
                flex: 2,
                child: IndexedStack(
                  index: _index,
                  children: _pages,
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  spacing: 8,
                  children: [
                    SettingSection.single(
                      title: '${_previewTitle()} Preview',
                      child: BiblePanePreview(mode: _previewMode),
                    ),
                    if (_index == 0)
                      Container(
                        padding: const EdgeInsets.only(left: 32),
                        child: Row(
                          children: [
                            const Text('modes: '),
                            IconButton(
                                tooltip: 'List',
                                onPressed: () => setState(() {
                                      _previewMode = DisplayMode.list;
                                    }),
                                icon: const Icon(Icons.list)),
                            IconButton(
                                tooltip: 'Presentation',
                                onPressed: () => setState(() {
                                      _previewMode = DisplayMode.presentation;
                                    }),
                                icon: const Icon(
                                    Icons.screenshot_monitor_rounded))
                          ],
                        ),
                      )
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
