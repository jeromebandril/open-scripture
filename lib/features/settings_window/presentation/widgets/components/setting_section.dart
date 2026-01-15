import 'package:flutter/material.dart';

class SettingSection extends StatelessWidget {
  const SettingSection(
      {super.key,
      required this.children,
      required this.title,
      this.rightSideChild});

  final String title;
  final List<Widget> children;
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
            color: Theme.of(context).colorScheme.surfaceDim,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(32),
          child: Row(
            spacing: 32,
            children: [
              //
              // LEFT SIDE
              //
              Expanded(
                flex: 2,
                child: Column(
                  children: _withDividers(children),
                ),
              ),
              //
              // RIGHT SIDE
              //
              if (rightSideChild != null)
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: rightSideChild!,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
