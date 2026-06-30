import 'package:flutter/material.dart';
import '../../design_system/tokens/radius.dart';

class BContainerTabBar extends StatefulWidget {
  const BContainerTabBar({
    super.key,
    required this.tabs,
    required this.views,
    this.height = 48.0,
    this.backgroundColor,
    this.viewBackgroundColor,
    this.onTabChanged,
    this.scrollableView = false,
    this.initialIndex = 0,
  }) : assert(tabs.length == views.length,
            "Tabs and views must have the same length");

  final List<String> tabs;
  final List<Widget> views;
  final double height;
  final Color? backgroundColor;
  final Color? viewBackgroundColor;
  final void Function(int index)? onTabChanged;
  final bool scrollableView;
  final int initialIndex;

  @override
  State<BContainerTabBar> createState() => _BContainerTabBarState();
}

class _BContainerTabBarState extends State<BContainerTabBar>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        widget.onTabChanged?.call(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        //
        // Tab Bar Container
        //
        Container(
          height: widget.height,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.height / 2),
            color:
                widget.backgroundColor ?? theme.colorScheme.surfaceContainerLow,
          ),
          child: TabBar(
            controller: _tabController,
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.height / 2 - 4),
              color: theme.colorScheme.primaryContainer,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: theme.colorScheme.onPrimaryContainer,
            unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
            splashBorderRadius: BorderRadius.circular(widget.height / 2 - 4),
            tabs: widget.tabs.map((t) => Tab(text: t)).toList(),
          ),
        ),
        //
        // View Area
        //
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
                color: widget.viewBackgroundColor,
                borderRadius: BorderRadius.circular(AppRadius.md)),
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: widget.scrollableView
                  ? widget.views.map((view) {
                      return SingleChildScrollView(
                        child: view,
                      );
                    }).toList()
                  : widget.views,
            ),
          ),
        ),
      ],
    );
  }
}
