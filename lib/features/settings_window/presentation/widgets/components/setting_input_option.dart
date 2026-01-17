import 'package:flutter/material.dart';

class SettingInputOption<T> extends StatefulWidget {
  const SettingInputOption({
    super.key,
    required this.items,
    this.onChanged,
    this.value,
  });

  final List<DropdownMenuItem<T>>? items;
  final Function(T?)? onChanged;
  final T? value;

  @override
  State<SettingInputOption<T>> createState() => _SettingInputOptionState<T>();
}

class _SettingInputOptionState<T> extends State<SettingInputOption<T>> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      isExpanded: true,
      isDense: true,
      items: widget.items as List<DropdownMenuItem<T>>,
      onChanged: widget.onChanged,
      value: widget.value,
    );
  }
}
