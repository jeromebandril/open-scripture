import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingInputNumber extends StatefulWidget {
  const SettingInputNumber({
    super.key,
    this.value,
    this.prefixIcon,
    this.onSubmitted,
    this.max,
    this.min = 0,
  });

  final String? value;
  final IconData? prefixIcon;
  final Function(double)? onSubmitted;
  final int? max;
  final int? min;

  @override
  State<SettingInputNumber> createState() => _SettingInputNumberState();
}

class _SettingInputNumberState extends State<SettingInputNumber> {
  late final TextEditingController _controller;
  bool _minReached = false;
  bool _maxReached = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()..text = widget.value ?? '';
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
          prefixIcon:
              widget.prefixIcon != null ? Icon(Icons.text_fields) : null,
        ),
      ),
    );
  }
}
