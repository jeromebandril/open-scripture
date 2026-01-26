import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../../core/domain/entities/verse_span.dart';

const strongWordBold = 'H0430';

class VerseSpanBuilder {
  static TextSpan build({
    required String text,
    required List<VerseSpan> spans,
    TextStyle? baseStyle,
    required void Function(VerseSpan span, String slice)? onWordTap,
    required BuildContext context,
  }) {
    baseStyle ??= const TextStyle();

    if (spans.isEmpty) {
      return TextSpan(text: text, style: baseStyle);
    }

    // 1) Collect boundaries
    final boundaries = <int>{0, text.length};
    for (final s in spans) {
      boundaries.add(s.startOffset.clamp(0, text.length));
      boundaries.add(s.endOffset.clamp(0, text.length));
    }

    final points = boundaries.toList()..sort();

    // Helper: get active spans for an interval
    List<VerseSpan> activeAt(int start, int end) {
      return spans
          .where((s) => s.startOffset <= start && s.endOffset >= end)
          .toList();
    }

    // EDIT HERE TO APPLY STYLES
    TextStyle applyStyles(TextStyle base, List<VerseSpan> active) {
      var style = base;

      for (final s in active) {
        switch (s.type) {
          case SpanType.italic:
            style = style.merge(TextStyle(
              fontStyle: FontStyle.italic,
              color: Theme.of(context).colorScheme.outline,
            ));
            break;
          case SpanType.bold:
            style = style.merge(const TextStyle(fontWeight: FontWeight.w600));
            break;
          case SpanType.wordOfJesus:
            // "small caps" isn't directly supported everywhere; approximate
            style = style.merge(TextStyle(color: Colors.red[900]));
            break;

          case SpanType.strongWords:
            style = style.merge(TextStyle(
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.dotted,
              decorationColor: Colors.black26,
              fontWeight: s.payload == strongWordBold ? FontWeight.w500 : null,
            ));
            break;
          default:
            break;
        }
      }

      return style;
    }

    // 2) Build children spans
    final children = <InlineSpan>[];

    for (var i = 0; i < points.length - 1; i++) {
      final start = points[i];
      final end = points[i + 1];
      if (start >= end) continue;

      final slice = text.substring(start, end);
      if (slice.isEmpty) continue;

      final active = activeAt(start, end);
      final style = applyStyles(baseStyle, active);

      // Optional: attach a recognizer for specific span types (e.g. "w")
      TapGestureRecognizer? recognizer;
      final tappable =
          active.where((s) => s.type == SpanType.strongWords).toList();
      if (tappable.isNotEmpty && onWordTap != null) {
        final first = tappable.first;
        recognizer = TapGestureRecognizer()
          ..onTap = () => onWordTap(first, slice);
      }

      children.add(TextSpan(
        text: slice,
        style: style,
        recognizer: recognizer,
      ));
    }

    return TextSpan(children: children, style: baseStyle);
  }
}
