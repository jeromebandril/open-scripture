import 'package:flutter/material.dart';

enum DestructiveButtonVariant {
  filled,
  outlined,
  text,
  icon,
  textWithIcon,
}

class DestructiveButton extends StatelessWidget {
  const DestructiveButton({
    super.key,
    required this.onPressed,
    required this.variant,
    this.child,
    this.icon,
    this.tooltip,
    this.style,
    this.focusNode,
    this.autofocus = false,
  }) : assert(
          variant == DestructiveButtonVariant.icon
              ? icon != null
              : child != null,
        );

  final VoidCallback? onPressed;
  final DestructiveButtonVariant variant;

  final Widget? child;
  final Widget? icon;
  final String? tooltip;

  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final destructiveStyle = ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colors.onSurface.withValues(alpha: 0.38);
        }

        return variant == DestructiveButtonVariant.filled
            ? colors.onError
            : colors.error;
      }),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (variant != DestructiveButtonVariant.filled) {
          return Colors.transparent;
        }

        if (states.contains(WidgetState.disabled)) {
          return colors.onSurface.withValues(alpha: 0.12);
        }

        return colors.error;
      }),
      overlayColor: WidgetStateProperty.all(
        colors.error.withValues(alpha: 0.12),
      ),
    ).merge(style);

    switch (variant) {
      case DestructiveButtonVariant.filled:
        return FilledButton(
          onPressed: onPressed,
          style: destructiveStyle,
          focusNode: focusNode,
          autofocus: autofocus,
          child: child!,
        );

      case DestructiveButtonVariant.outlined:
        return OutlinedButton(
          onPressed: onPressed,
          style: destructiveStyle.copyWith(
            side: WidgetStateProperty.all(
              BorderSide(color: colors.error),
            ),
          ),
          focusNode: focusNode,
          autofocus: autofocus,
          child: child!,
        );

      case DestructiveButtonVariant.text:
        return TextButton(
          onPressed: onPressed,
          style: destructiveStyle,
          focusNode: focusNode,
          autofocus: autofocus,
          child: child!,
        );

      case DestructiveButtonVariant.icon:
        return IconButton(
          onPressed: onPressed,
          tooltip: tooltip,
          style: IconButton.styleFrom(
            foregroundColor: colors.error,
            overlayColor: colors.error.withValues(alpha: 0.12),
          ).merge(style),
          focusNode: focusNode,
          autofocus: autofocus,
          icon: icon!,
        );

      case DestructiveButtonVariant.textWithIcon:
        return TextButton.icon(
          onPressed: onPressed,
          style: destructiveStyle,
          focusNode: focusNode,
          autofocus: autofocus,
          icon: icon!,
          label: child!,
        );
    }
  }
}
