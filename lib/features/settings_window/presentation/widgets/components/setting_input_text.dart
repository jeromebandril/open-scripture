import 'package:flutter/material.dart';

class SettingInputText extends StatefulWidget {
  const SettingInputText({
    super.key,
    this.value,
    this.prefixIcon,
    this.onSubmitted,
  });

  final String? value;
  final IconData? prefixIcon;
  final Function(String)? onSubmitted;

  @override
  State<SettingInputText> createState() => _SettingInputTextState();
}

class _SettingInputTextState extends State<SettingInputText> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()..text = widget.value ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: TextField(
        controller: _controller,
        onSubmitted: (text) => widget.onSubmitted?.call(text),
        decoration: InputDecoration(
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
