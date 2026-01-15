import 'package:flutter/material.dart';

class SettingBoolInput extends StatefulWidget {
  const SettingBoolInput({
    super.key,
    this.onChanged,
    required this.value,
  });

  final Function(bool value)? onChanged;
  final bool value;

  @override
  State<SettingBoolInput> createState() => _SettingBoolInputState();
}

class _SettingBoolInputState extends State<SettingBoolInput> {
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
          color: widget.value ? Colors.blue : Colors.grey.shade400,
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
