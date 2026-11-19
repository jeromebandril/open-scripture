import 'package:flutter/material.dart';

class FlexDataTable<T> extends StatelessWidget {
  final List<T> items;
  final List<FlexTableColumn<T>> columns;

  final double rowHeight;
  final double headerHeight;

  final Color? headerColor;
  final Color? rowColor;
  final Color? borderColor;

  final bool shrinkWrap;

  final ValueChanged<T>? onSelectItem;
  final T? selectedItem;

  const FlexDataTable({
    super.key,
    required this.items,
    required this.columns,
    this.rowHeight = 48,
    this.headerHeight = 52,
    this.headerColor,
    this.rowColor,
    this.borderColor,
    this.shrinkWrap = false,
    this.onSelectItem,
    this.selectedItem,
  }) : assert(columns.length > 0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final dataRows = ListView.builder(
      shrinkWrap: shrinkWrap,
      itemCount: items.length,
      itemExtent: rowHeight,
      itemBuilder: (context, index) {
        final item = items[index];

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onSelectItem?.call(item),
            canRequestFocus: false,
            hoverColor: theme.colorScheme.surfaceContainer,
            child: Container(
              height: rowHeight,
              decoration: BoxDecoration(
                color: item == selectedItem
                    ? theme.colorScheme.surfaceContainer
                    : rowColor,
                border: Border(
                  bottom: BorderSide(
                    color: borderColor ?? theme.dividerColor,
                  ),
                ),
              ),
              child: Row(
                children: columns.map((column) {
                  return Expanded(
                    flex: column.flex,
                    child: Padding(
                      padding: column.padding,
                      child: Align(
                        alignment: column.alignment,
                        child: column.cellBuilder(context, item),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );

    if (shrinkWrap) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          dataRows,
        ],
      );
    }

    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: dataRows,
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: headerHeight,
      child: Container(
        color: headerColor,
        child: Row(
          children: columns.map((column) {
            return Expanded(
              flex: column.flex,
              child: Padding(
                padding: column.padding,
                child: Align(
                  alignment: column.alignment,
                  child: column.header,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class FlexTableColumn<T> {
  final Widget header;
  final Widget Function(BuildContext context, T item) cellBuilder;

  final int flex;
  final Alignment alignment;
  final EdgeInsetsGeometry padding;

  const FlexTableColumn({
    required this.header,
    required this.cellBuilder,
    this.flex = 1,
    this.alignment = Alignment.centerLeft,
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
  }) : assert(flex > 0);
}
