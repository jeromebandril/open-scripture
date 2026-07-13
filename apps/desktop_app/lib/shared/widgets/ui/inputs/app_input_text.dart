import 'dart:async';
import 'package:flutter/material.dart';

class AppInputText extends StatefulWidget {
  const AppInputText({
    super.key,
    this.value,
    this.hint,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.focusNode,
    this.debounce,
    this.onChanged,
    this.onSubmitted,
  });

  final String? value;
  final String? hint;
  final String? label;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool enabled;
  final FocusNode? focusNode;

  /// When set, [onChanged] fires [debounce] after the last keystroke
  /// instead of on every keystroke. Submitting (Enter) always flushes any
  /// pending call immediately. Leave null for fire-on-every-keystroke behavior.
  final Duration? debounce;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  State<AppInputText> createState() => _AppInputTextState();
}

class _AppInputTextState extends State<AppInputText> {
  late final TextEditingController _controller;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value ?? '');
  }

  @override
  void didUpdateWidget(AppInputText old) {
    super.didUpdateWidget(old);
    if (widget.value != old.value && widget.value != _controller.text) {
      // Preserve cursor position on external value updates
      _controller.value = _controller.value.copyWith(text: widget.value ?? '');
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _handleChanged(String value) {
    final debounce = widget.debounce;
    if (debounce == null) {
      widget.onChanged?.call(value);
      return;
    }
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounce, () => widget.onChanged?.call(value));
  }

  void _handleSubmitted(String value) {
    // Flush a pending debounced call so listeners aren't stale after submit.
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
      widget.onChanged?.call(value);
    }
    widget.onSubmitted?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      mouseCursor: widget.enabled
          ? SystemMouseCursors.text
          : SystemMouseCursors.forbidden,
      controller: _controller,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      onChanged: _handleChanged,
      onSubmitted:
          widget.debounce != null ? _handleSubmitted : widget.onSubmitted,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: widget.hint,
        labelText: widget.label,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        suffixIcon: widget.suffixIcon != null ? Icon(widget.suffixIcon) : null,
      ),
    );
  }
}
