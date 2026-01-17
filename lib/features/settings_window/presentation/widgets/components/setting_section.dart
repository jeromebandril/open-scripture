import 'package:flutter/material.dart';

class SettingSection extends StatelessWidget {
  const SettingSection({
    super.key,
    required this.title,
    this.children,
    this.rightSideChild,
  });

  final String title;
  final List<Widget>? children;
  final Widget? rightSideChild;

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
  });

  final String title;
  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;
  final bool isLoading;
  final bool isError;
  final Widget? emptyListPlaceholder;
  final Widget? errorPlaceholder;

  Widget _builder() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (isError) {
      return errorPlaceholder ?? Text('Error');
    }
    if (itemCount == 0) {
      return emptyListPlaceholder ?? Text('Empty');
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
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ),
            SizedBox(width: 150, child: TextField()),
          ],
        ),
        SizedBox(height: 12),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(32),
            child: _builder(),
          ),
        ),
      ],
    );
  }
}
