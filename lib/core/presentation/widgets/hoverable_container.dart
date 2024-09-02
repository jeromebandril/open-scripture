import 'package:flutter/material.dart';

class HoverableContainer extends StatefulWidget {
  final Function()? onEnter;
  final Function()? onExit;
  final Color? initialColor;
  final Color hoveredColor;
  final Widget child;
  final double? height;
  final double? width;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry? padding;

  const HoverableContainer({
    super.key,
    this.initialColor,
    required this.hoveredColor,
    required this.child,
    this.height,
    this.width,
    this.decoration,
    this.padding,
    this.onEnter,
    this.onExit,
  });

  @override
  State<HoverableContainer> createState() => _HoverableContainerState();
}

class _HoverableContainerState extends State<HoverableContainer> {
  Color? _backgroundColor;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        widget.onEnter != null ? widget.onEnter!() : null;
        _onEnter(_);
      },
      onExit: (_) {
        widget.onExit != null ? widget.onExit!() : null;
        _onExit(_);
      },
      child: Container(
        padding: widget.padding,
        width: widget.width,
        height: widget.height,
        decoration: widget.decoration?.copyWith(color: _backgroundColor),
        color: widget.decoration == null ? _backgroundColor : null,
        child: widget.child,
      ),
    );
  }

  void _onEnter(_) {
    setState(() {
      _backgroundColor = widget.hoveredColor;
    });
  }

  void _onExit(_) {
    setState(() {
      _backgroundColor = widget.initialColor;
    });
  }
}
