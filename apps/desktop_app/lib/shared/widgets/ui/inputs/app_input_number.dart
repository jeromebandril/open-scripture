import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppInputNumber extends StatefulWidget {
  const AppInputNumber({
    super.key,
    this.value,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.max,
    this.min,
    this.decimal = false,
    this.enabled = true,
  });

  final num? value;
  final IconData? suffixIcon;
  final ValueChanged<num>? onChanged;
  final ValueChanged<num>? onSubmitted;
  final num? max;
  final num? min;

  /// Allow decimal input. Defaults to false (integer only).
  final bool decimal;
  final bool enabled;

  @override
  State<AppInputNumber> createState() => _AppInputNumberState();
}

class _AppInputNumberState extends State<AppInputNumber> {
  late final TextEditingController _controller;
  bool _minReached = false;
  bool _maxReached = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value?.toString() ?? '');
    _controller.addListener(_validate);
  }

  @override
  void didUpdateWidget(AppInputNumber old) {
    super.didUpdateWidget(old);
    if (widget.value != old.value) {
      final String text = widget.value?.toString() ?? '';
      if (text != _controller.text) {
        _controller.value = _controller.value.copyWith(text: text);
      }
    }
    if (widget.min != old.min || widget.max != old.max) _validate();
  }

  @override
  void dispose() {
    _controller.removeListener(_validate);
    _controller.dispose();
    super.dispose();
  }

  num? get _parsed => num.tryParse(_controller.text);

  void _validate() {
    final num? n = _parsed;
    if (n == null) return;

    final bool minReached = widget.min != null && n < widget.min!;
    final bool maxReached = widget.max != null && n > widget.max!;

    if (minReached != _minReached || maxReached != _maxReached) {
      setState(() {
        _minReached = minReached;
        _maxReached = maxReached;
      });
    }
  }

  bool get _isValid => !_minReached && !_maxReached;

  String? get _errorText {
    if (_minReached) return 'Minimum value is ${widget.min}';
    if (_maxReached) return 'Maximum value is ${widget.max}';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      mouseCursor: widget.enabled
          ? SystemMouseCursors.text
          : SystemMouseCursors.forbidden,
      enabled: widget.enabled,
      textAlign: TextAlign.end,
      controller: _controller,
      style: Theme.of(context).textTheme.bodyMedium,
      keyboardType: TextInputType.numberWithOptions(
        signed: false,
        decimal: widget.decimal,
      ),
      inputFormatters: [
        widget.decimal
            ? FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
            : FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (text) {
        final num? n = _parsed;
        if (n != null && _isValid) widget.onChanged?.call(n);
      },
      onSubmitted: (text) {
        final num? n = _parsed;
        if (n != null && _isValid) widget.onSubmitted?.call(n);
      },
      decoration: InputDecoration(
        errorText: _errorText,
        suffixIcon: widget.suffixIcon != null ? Icon(widget.suffixIcon) : null,
      ),
    );
  }
}
