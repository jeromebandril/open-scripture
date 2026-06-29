import 'package:flutter/material.dart';

class AppInputOption<T> extends StatefulWidget {
  const AppInputOption({
    super.key,
    required this.items,
    this.onChanged,
    this.value,
  });

  final List<DropdownMenuItem<T>>? items;
  final Function(T?)? onChanged;
  final T? value;

  @override
  State<AppInputOption<T>> createState() => _AppInputOptionState<T>();
}

class _AppInputOptionState<T> extends State<AppInputOption<T>> {
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
