import 'package:flutter/material.dart';

import '../../../../../shared/widgets/ui/b_container_tab_bar.dart';
import 'bible_pane_general_customizer_screen.dart';
import 'bible_view_list_customizer_screen.dart';
import 'bible_view_presentation_customizer_screen.dart';
import 'bible_view_prose_customizer_screen.dart';

class BiblePaneCustomizerScreen extends StatefulWidget {
  const BiblePaneCustomizerScreen({super.key});

  @override
  State<BiblePaneCustomizerScreen> createState() =>
      _BiblePaneCustomizerScreenState();
}

class _BiblePaneCustomizerScreenState extends State<BiblePaneCustomizerScreen> {
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const BiblePaneGeneralCustomizerScreen(),
      const BibleViewListCustomizerScreen(),
      const BibleViewPresentationCustomizerScreen(),
      const BibleViewProseCustomizerScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(42, 0, 42, 42),
      child: BContainerTabBar(
        tabs: ['General', 'List View', 'Presentation View', 'Prose View'],
        views: _pages,
      ),
    );
  }
}
