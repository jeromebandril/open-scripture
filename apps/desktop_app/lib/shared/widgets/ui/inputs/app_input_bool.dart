import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../design_system/design_system.dart';

class AppInputBool extends StatefulWidget {
  const AppInputBool({
    super.key,
    required this.value,
    this.onChanged,
    this.enabled = true,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;

  @override
  State<AppInputBool> createState() => _AppInputBoolState();
}

class _AppInputBoolState extends State<AppInputBool> {
  bool _focused = false;

  void _handleTap() {
    if (widget.enabled) {
      widget.onChanged?.call(!widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    final Color trackColor = !widget.enabled
        ? cs.onSurface.withValues(alpha: 0.12)
        : widget.value
            ? cs.primary
            : cs.surfaceContainer;

    final Color thumbColor = !widget.enabled
        ? cs.onSurface.withValues(alpha: 0.38)
        : widget.value
            ? cs.onPrimary
            : cs.onSurfaceVariant;

    return Semantics(
      toggled: widget.value,
      enabled: widget.enabled,
      button: true,
      label: 'Color',
      child: FocusableActionDetector(
        enabled: widget.enabled,
        onFocusChange: (focused) {
          setState(() => _focused = focused);
        },
        mouseCursor: widget.enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.forbidden,
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        },
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              _handleTap();
              return null;
            },
          ),
        },
        child: GestureDetector(
          onTap: widget.enabled ? _handleTap : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: 44,
            height: 24,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: AppRadius.radiusFull,
              color: trackColor,
              border:
                  _focused ? Border.all(color: cs.primary, width: 1.5) : null,
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment:
                  widget.value ? Alignment.centerRight : Alignment.centerLeft,
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
