import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../../shared/domain/entities/verse.dart';
import '../../../../customizer/presentation/models/bible_pane_general_theme.dart';

const _strongWordBold = 'H0430';

class VerseSpanBuilder {
  static List<InlineSpan> build({
    required List<VerseSpan> spans,
    required BuildContext context,
    TextStyle? baseStyle,
    void Function(VerseSpan span)? onWordTap,
    VoidCallback? onVerseTap,
    int? colorAlpha,
  }) {
    if (spans.isEmpty) return const [];

    final theme = Theme.of(context);
    final bTheme = theme.extension<BiblePaneGeneralTheme>()!;
    final base = baseStyle ?? const TextStyle();

    return spans.map((span) {
      final isStrongsWord = span.activeStyles.contains(SpanType.strongs);

      GestureRecognizer? recognizer;
      if (isStrongsWord && onWordTap != null) {
        recognizer = TapGestureRecognizer()..onTap = () => onWordTap(span);
      } else if (onVerseTap != null) {
        recognizer = TapGestureRecognizer()..onTap = onVerseTap;
      }

      TextStyle style = _buildCombinedStyle(span, base, bTheme);
      if (style.color == null) {
        style = style.copyWith(
            color: bTheme.enableCustomTheme
                ? bTheme.textColor
                : theme.colorScheme.onSurfaceVariant);
      }
      if (colorAlpha != null) {
        style = style.copyWith(color: style.color!.withAlpha(colorAlpha));
      }

      return TextSpan(
        text: span.text,
        // Apply all styles cumulatively
        style: style,
        recognizer: recognizer,
      );
    }).toList();
  }

  static TextStyle _buildCombinedStyle(
    VerseSpan span,
    TextStyle base,
    BiblePaneGeneralTheme bTheme,
  ) {
    TextStyle style = base;

    // Apply styles in order of priority or accumulation
    for (final type in span.activeStyles) {
      style = style.merge(_getStyleForType(type, span, bTheme));
    }

    return style;
  }

  static TextStyle _getStyleForType(
    SpanType type,
    VerseSpan span,
    BiblePaneGeneralTheme bTheme,
  ) {
    return switch (type) {
      SpanType.italic => const TextStyle(fontStyle: FontStyle.italic),
      SpanType.bold => const TextStyle(fontWeight: FontWeight.w600),
      SpanType.added =>
        TextStyle(fontStyle: FontStyle.italic, color: bTheme.addColor),
      SpanType.redLetter => TextStyle(color: bTheme.quoteColor),
      SpanType.strongs => TextStyle(
          decoration: bTheme.underlineStrongWords
              ? TextDecoration.underline
              : TextDecoration.none,
          decorationStyle: TextDecorationStyle.dotted,
          decorationColor: Colors.black26,
          fontWeight: span.payload == _strongWordBold ? FontWeight.w500 : null,
        ),
      SpanType.underline =>
        const TextStyle(decoration: TextDecoration.underline),
      SpanType.smallCaps =>
        const TextStyle(fontFeatures: [FontFeature.enable('smcp')]),
      SpanType.superscript => const TextStyle(fontSize: 10, height: 0.5),
      _ => const TextStyle(),
    };
  }
}
