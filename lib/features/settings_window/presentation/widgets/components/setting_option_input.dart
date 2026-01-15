import 'package:flutter/material.dart';

class SettingOptionInput<T> extends StatefulWidget {
  const SettingOptionInput({
    super.key,
    required this.items,
    this.onChanged,
    this.value,
  });

  final List<DropdownMenuItem<T>>? items;
  final Function(T?)? onChanged;
  final T? value;

  @override
  State<SettingOptionInput<T>> createState() => _SettingOptionInputState<T>();
}

class _SettingOptionInputState<T> extends State<SettingOptionInput<T>> {
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
