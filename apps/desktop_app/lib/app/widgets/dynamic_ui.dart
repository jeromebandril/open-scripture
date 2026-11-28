import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/bible_searchbar/history/presentation/widgets/history_list.dart';
import '../../features/bible_searchbar/search/presentation/widgets/bible_searchbar.dart';
import '../../features/shortcuts/presentation/widgets/shortcuts_focus_scope.dart';
import '../../shared/design_system/design_system.dart';
import '../../shared/presentation/widgets/floating_panel.dart';
import '../state/interface_visibility_cubit.dart';

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

class DynamicHistory extends StatelessWidget {
  const DynamicHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final showHistory = context.select(
      (InterfaceVisibilityCubit i) => i.state.isHistoryVisible,
    );

    return FloatingPanel(
      visible: showHistory,
      maintainState: false,
      top: screen.height * 0.08 + 100,
      left: 0,
      right: 0,
      width: 320,
      height: 250,
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: const HistoryList(size: HistoryListSize.big),
    );
  }
}
