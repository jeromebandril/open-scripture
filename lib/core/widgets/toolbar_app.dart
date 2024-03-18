import 'package:flutter/material.dart';

/// Usually a top widget, adds a desktop toolbar
/// look on top of the application
class ToolbarApp extends StatelessWidget {
  final Widget child;
  final List<ToolbarOption> options;

  const ToolbarApp({
    required this.options,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 24,
          child: Row(children: options),
        ),
        Expanded(child: child),
      ],
    );
  }
}

class ToolbarOption extends StatefulWidget {
  final String text;

  const ToolbarOption({
    required this.text,
    super.key,
  });

  @override
  State<ToolbarOption> createState() => _ToolbarOptionState();
}

class _ToolbarOptionState extends State<ToolbarOption> {
  Color hoverColor = Colors.green;
  Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      onHover: _onHover,
      child: Container(
        color: color,
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 3,
        ),
        child: Text(widget.text),
      ),
    );
  }

  void _onHover(isHovered) {
    setState(() {
      color = isHovered ? hoverColor : null;
    });
  }
}
