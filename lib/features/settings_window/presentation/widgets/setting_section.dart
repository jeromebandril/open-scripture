import 'package:flutter/material.dart';
import 'package:the_smyrna_bible_v2/core/presentation/widgets/debounce_textfield.dart';

class SettingSection extends StatelessWidget {
  const SettingSection({
    super.key,
    required this.title,
    this.children,
    this.rightSideChild,
  })  : itemCount = null,
        itemBuilder = null;

  const SettingSection.builder({
    super.key,
    required this.title,
    required this.itemCount,
    required this.itemBuilder,
  })  : children = null,
        rightSideChild = null;

  final String title;
  final List<Widget>? children;
  final Widget? rightSideChild;
  final int? itemCount;
  final NullableIndexedWidgetBuilder? itemBuilder;

  List<Widget> _withDividers(
    List<Widget> children, {
    Widget divider = const Divider(),
  }) {
    if (children.isEmpty) return const [];
    return [
      for (int i = 0; i < children.length; i++) ...[
        if (i > 0) divider,
        children[i],
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
        ),
        SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(32),
          child: Row(
            spacing: 32,
            children: [
              //
              // LEFT SIDE
              //
              if (itemBuilder != null)
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (_, __) => Divider(),
                    shrinkWrap: true,
                    itemCount: itemCount!,
                    itemBuilder: itemBuilder!,
                  ),
                ),

              if (children != null)
                Expanded(
                  flex: 2,
                  child: Column(
                    children: _withDividers(children!),
                  ),
                ),
              //
              // RIGHT SIDE
              //
              if (rightSideChild != null)
                Expanded(
                  flex: 1,
                  //fit: FlexFit.loose,
                  child: rightSideChild!,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class SettingListSection extends StatelessWidget {
  const SettingListSection({
    super.key,
    required this.title,
    required this.itemCount,
    required this.itemBuilder,
    this.isLoading = false,
    this.isError = false,
    this.errorPlaceholder,
    this.emptyListPlaceholder,
    this.separatorBuilder,
    this.onFilter,
  });

  final String title;
  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final bool isLoading;
  final bool isError;
  final Widget? emptyListPlaceholder;
  final Widget? errorPlaceholder;
  final Function(String)? onFilter;

  Widget _builder() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (isError) {
      return Center(child: errorPlaceholder ?? Text('Error'));
    }
    if (itemCount == 0) {
      return Center(child: emptyListPlaceholder ?? Text('Empty'));
    }
    if (separatorBuilder != null) {
      return ListView.separated(
        itemBuilder: itemBuilder,
        separatorBuilder: separatorBuilder!,
        itemCount: itemCount,
      );
    }

    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 32, bottom: 12),
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ),

            // Connected to the main part
            Container(
              decoration: BoxDecoration(
                //color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              width: 250,
              child: DebouncedTextField(
                onDebouncedChanged: (String value) => onFilter?.call(value),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Filter',
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                  // prefixIcon: Icon(
                  //   Icons.search,
                  //   size: 14,
                  // ),
                ),
              ),
            ),
          ],
        ),
        // Main part
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            padding: EdgeInsets.all(32),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _builder(),
            ),
          ),
        ),
      ],
    );
  }
}
