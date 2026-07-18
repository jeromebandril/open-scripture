import 'package:flutter/material.dart';
import '../../features/bible_searchbar/search/presentation/widgets/bible_searchbar.dart';
import '../../features/shortcuts/presentation/widgets/shortcuts_focus_scope.dart';
import '../../shared/design_system/design_system.dart';
import '../../shared/widgets/floating_panel.dart';

class DynamicSearchbar extends StatelessWidget {
  const DynamicSearchbar({super.key});

  @override
  Widget build(BuildContext context) {
    final focusNode = ShortcutFocusScope.of(context).search
      ..skipTraversal = true;

    final screen = MediaQuery.of(context).size;
    // Use the [FloatingPanel] style
    final sTheme = Theme.of(context).searchBarTheme.copyWith(
          backgroundColor: WidgetStatePropertyAll(Colors.transparent),
          side: WidgetStatePropertyAll(BorderSide.none),
        );

    return ListenableBuilder(
      listenable: focusNode,
      builder: (context, _) => FloatingPanel(
        padding: EdgeInsetsGeometry.zero,
        visible: focusNode.hasFocus,
        top: screen.height * 0.08,
        left: 0,
        right: 0,
        decoration: BoxDecoration(
          color: Theme.of(context).dividerColor,
          borderRadius: AppRadius.input,
          border:
              BoxBorder.all(width: 4, color: Theme.of(context).dividerColor),
        ),
        child: BSearchbar(height: 56, width: 300, theme: sTheme),
      ),
    );
  }
}
