import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';

class AppInputBool extends StatelessWidget {
  const AppInputBool({
    super.key,
    required this.value,
    this.onChanged,
    this.enabled = true,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;

  void _handleTap() {
    if (enabled) onChanged?.call(!value);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    final Color trackColor = !enabled
        ? cs.onSurface.withValues(alpha: 0.12)
        : value
            ? cs.primary
            : cs.surfaceContainer;

    final Color thumbColor = !enabled
        ? cs.onSurface.withValues(alpha: 0.38)
        : value
            ? cs.onPrimary
            : cs.onSurfaceVariant;

    return Semantics(
      toggled: value,
      enabled: enabled,
      label: 'Toggle',
      child: MouseRegion(
        cursor:
            enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
        child: GestureDetector(
          onTap: _handleTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: 44,
            height: 24,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: AppRadius.radiusFull,
              color: trackColor,
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: thumbColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
