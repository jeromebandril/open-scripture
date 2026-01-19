import 'package:flutter/material.dart';

class SettingInputBool extends StatefulWidget {
  const SettingInputBool({
    super.key,
    this.onChanged,
    required this.value,
  });

  final Function(bool value)? onChanged;
  final bool value;

  @override
  State<SettingInputBool> createState() => _SettingInputBoolState();
}

class _SettingInputBoolState extends State<SettingInputBool> {
  @override
  Widget build(BuildContext context) {
    //return Switch.adaptive(value: widget.value, onChanged: widget.onChanged);
    return GestureDetector(
      onTap: () => widget.onChanged?.call(!widget.value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 24,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: widget.value
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade400,
        ),
        child: Align(
          alignment:
              widget.value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
