import 'package:flutter/material.dart';

class SettingTextInput extends StatefulWidget {
  const SettingTextInput({
    super.key,
    this.value,
    this.prefixIcon,
  });

  final String? value;
  final IconData? prefixIcon;

  @override
  State<SettingTextInput> createState() => _SettingTextInputState();
}

class _SettingTextInputState extends State<SettingTextInput> {
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
