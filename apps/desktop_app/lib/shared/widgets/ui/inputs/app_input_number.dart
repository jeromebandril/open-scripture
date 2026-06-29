import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppInputNumber extends StatefulWidget {
  const AppInputNumber({
    super.key,
    this.value,
    this.suffixIcon,
    this.onSubmitted,
    this.max,
    this.min = 0,
    this.isDisabled = false,
  });

  final num? value;
  final IconData? suffixIcon;
  final Function(num)? onSubmitted;
  final int? max;
  final int? min;
  final bool isDisabled;

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
    _controller = TextEditingController()
      ..text = widget.value?.toString() ?? '';
    _controller.addListener(_sanityCheck);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sanityCheck() {
    final n = double.tryParse(_controller.text);

    if (n == null) return;

    bool isMin = false;
    if (widget.min != null && n < widget.min!) {
      isMin = true;
      if (isMin && _minReached) return;
      setState(() => _minReached = true);
      return;
    }
    bool isMax = false;
    if (widget.max != null && n > widget.max!) {
      isMax = true;
      if (isMax && _maxReached) return;
      setState(() => _maxReached = true);
      return;
    }
    if (_maxReached || _minReached) {
      setState(() {
        _minReached = false;
        _maxReached = false;
      });
    }
  }

  String? _errorBuilder() {
    if (_minReached) return 'min of ${widget.min} reached';
    if (_maxReached) return 'max of ${widget.max} reached';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: TextField(
        enabled: !widget.isDisabled,
        textAlign: TextAlign.end,
        controller: _controller,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        onSubmitted: (number) {
          if (_minReached || _maxReached) return;
          widget.onSubmitted?.call(double.parse(number));
        },
        decoration: InputDecoration(
          visualDensity: VisualDensity.compact,
          errorText: _errorBuilder(),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          border: OutlineInputBorder(),
          suffixIcon:
              widget.suffixIcon != null ? Icon(widget.suffixIcon) : null,
        ),
      ),
    );
  }
}
