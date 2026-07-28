import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../../shared/domain/entities/verse.dart';
import '../../../settings/presentation/models/bible_view_font_weight_flutter.dart';
import '../../../settings/bible_view_settings.dart';
import '../../../settings/presentation/widgets/bible_view_settings_provider.dart';

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

    final appTheme = Theme.of(context);
    final viewSettings = BibleViewSettingsScope.of(context);
    final base = baseStyle ?? const TextStyle();

    return spans.map((span) {
      final isStrongsWord = span.activeStyles.contains(SpanType.strongs);

      GestureRecognizer? recognizer;
      if (isStrongsWord && onWordTap != null) {
        recognizer = TapGestureRecognizer()..onTap = () => onWordTap(span);
      } else if (onVerseTap != null) {
        recognizer = TapGestureRecognizer()..onTap = onVerseTap;
      }

      TextStyle style = _buildCombinedStyle(span, base, viewSettings);
      if (style.color == null) {
        style = style.copyWith(
            color: viewSettings.enableCustomTheme
                ? viewSettings.textColor
                : appTheme.colorScheme.onSurfaceVariant);
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
    BibleViewSettings viewSettings,
  ) {
    TextStyle style = base;

    // Apply styles in order of priority or accumulation
    for (final type in span.activeStyles) {
      style = style.merge(_getStyleForType(type, span, viewSettings));
    }

    return style;
  }

  static TextStyle _getStyleForType(
    SpanType type,
    VerseSpan span,
    BibleViewSettings viewSettings,
  ) {
    return switch (type) {
      SpanType.italic => const TextStyle(fontStyle: FontStyle.italic),
      SpanType.bold => const TextStyle(fontWeight: FontWeight.w600),
      SpanType.added =>
        TextStyle(fontStyle: FontStyle.italic, color: viewSettings.addColor),
      SpanType.redLetter => TextStyle(color: viewSettings.quoteColor),
      SpanType.strongs => TextStyle(
          decoration: viewSettings.underlineStrongWords
              ? TextDecoration.underline
              : TextDecoration.none,
          decorationStyle: TextDecorationStyle.dotted,
          decorationColor: Colors.black26,
          fontWeight: span.payload == _strongWordBold
              ? viewSettings.textFontWeight.toFlutter().stepUp()
              : null,
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

extension _FontWeightX on FontWeight {
  FontWeight stepUp() {
    final currentIndex = FontWeight.values.indexOf(this);
    if (currentIndex == -1 || currentIndex >= FontWeight.values.length - 1) {
      return FontWeight.w900;
    }
    return FontWeight.values[currentIndex + 1];
  }
}
