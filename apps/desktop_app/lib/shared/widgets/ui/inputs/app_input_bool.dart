import 'package:flutter/material.dart';

class AppInputBool extends StatefulWidget {
  const AppInputBool({
    super.key,
    this.onChanged,
    required this.value,
    this.isDisabled = false,
  });

  final Function(bool value)? onChanged;
  final bool value;
  final bool isDisabled;

  @override
  State<AppInputBool> createState() => _AppInputBoolState();
}

class _AppInputBoolState extends State<AppInputBool> {
  @override
  Widget build(BuildContext context) {
    //return Switch.adaptive(value: widget.value, onChanged: widget.onChanged);
    return GestureDetector(
      onTap: widget.isDisabled
          ? null
          : () => widget.onChanged?.call(!widget.value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 24,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: widget.isDisabled
              ? Colors.grey.shade300
              : widget.value
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
