import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:open_scripture/features/customizer/presentation/models/bible_pane_general_theme.dart';
import 'package:open_scripture/shared/domain/entities/verse.dart';

const _strongWordBold = 'H0430';

class VerseSpanBuilder {
  /// Converts a list of [VerseSpan] domain objects into Flutter [InlineSpan]s.
  /// No offset arithmetic needed - each span already owns its text.
  static List<InlineSpan> build({
    required List<VerseSpan> spans,
    required BuildContext context,
    TextStyle? baseStyle,
    void Function(VerseSpan span)? onWordTap,
  }) {
    if (spans.isEmpty) return const [];

    final bTheme = Theme.of(context).extension<BiblePaneGeneralTheme>()!;
    final base = baseStyle ?? const TextStyle();

    return spans.map((span) {
      return TextSpan(
        text: span.text,
        style: _styleFor(span, base, bTheme),
        recognizer: span.type == SpanType.strongs && onWordTap != null
            ? (TapGestureRecognizer()..onTap = () => onWordTap(span))
            : null,
      );
    }).toList();
  }

  static TextStyle _styleFor(
    VerseSpan span,
    TextStyle base,
    BiblePaneGeneralTheme bTheme,
  ) {
    return switch (span.type) {
      SpanType.italic => base.merge(
          const TextStyle(fontStyle: FontStyle.italic),
        ),
      SpanType.bold => base.merge(
          const TextStyle(fontWeight: FontWeight.w600),
        ),
      SpanType.added => base.merge(TextStyle(
          fontStyle: FontStyle.italic,
          color: bTheme.addColor,
        )),
      SpanType.redLetter => base.merge(
          TextStyle(color: bTheme.quoteColor),
        ),
      SpanType.strongs => base.merge(TextStyle(
          decoration: bTheme.underlineStrongWords
              ? TextDecoration.underline
              : TextDecoration.none,
          decorationStyle: TextDecorationStyle.dotted,
          decorationColor: Colors.black26,
          fontWeight: span.payload == _strongWordBold ? FontWeight.w500 : null,
        )),
      SpanType.underline => base.merge(
          const TextStyle(decoration: TextDecoration.underline),
        ),
      SpanType.smallCaps => base.merge(
          const TextStyle(fontFeatures: [FontFeature.enable('smcp')]),
        ),
      SpanType.superscript => base.merge(
          // Flutter has no native superscript; approximate with smaller size.
          // Replace with WidgetSpan + Transform if you need precision.
          const TextStyle(fontSize: 10, height: 0.5),
        ),
      // footnote, crossReference, poetry, reference. No visual style yet,
      // wire up when you build those interaction layers.
      _ => base,
    };
  }
}
