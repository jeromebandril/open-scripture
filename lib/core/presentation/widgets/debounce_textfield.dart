import 'dart:async';
import 'package:flutter/material.dart';

class DebouncedTextField extends StatefulWidget {
  const DebouncedTextField({
    super.key,
    required this.onDebouncedChanged,
    this.delay = const Duration(milliseconds: 800),
    this.decoration,
    this.controller,
    this.style,
    this.keyboardType,
    this.textInputAction,
  });

  final Duration delay;
  final ValueChanged<String> onDebouncedChanged;

  // Forwarded TextField params
  final InputDecoration? decoration;
  final TextEditingController? controller;
  final TextStyle? style;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  State<DebouncedTextField> createState() => _DebouncedTextFieldState();
}

class _DebouncedTextFieldState extends State<DebouncedTextField> {
  Timer? _debounce;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(widget.delay, () {
      widget.onDebouncedChanged(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: _onChanged,
      decoration: widget.decoration,
      style: widget.style,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
    );
  }
}
