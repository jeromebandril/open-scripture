import '../../../../shared/domain/entities/verse.dart';
import '../../domain/service/verse_html_formatter.dart';

/// Converts a list of [VerseSpan]s into an HTML fragment.
///
/// Each span's [VerseSpan.activeStyles] are mapped to CSS classes (see
/// [defaultClassNames]) and combined into a single wrapping element, since a
/// span commonly carries more than one style at once (e.g. bold + redLetter).
/// Actual visual styling is left entirely to the stylesheet, since this class
/// only decides *which* classes and data attributes go on the markup.
///
/// Usage:
/// ```dart
/// final formatter = VerseHtmlFormatter();
/// final html = formatter.toHtml(verseSpans);
/// // Drop `html` into a WebView, e.g.:
/// // controller.loadHtmlString(
/// //   '<html><head><style>...</style></head><body>$html</body></html>',
/// // );
/// ```
class VerseHtmlFormatterImpl implements VerseHtmlFormatter {
  const VerseHtmlFormatterImpl({
    this.classNames = defaultClassNames,
    this.convertNewlinesToBreaks = true,
  });

  /// Maps each [SpanType] to the CSS class applied when it's active
  final Map<SpanType, String> classNames;

  /// If true, literal `\n` / `\r\n` inside a span's text become `<br>`.
  /// Handy for poetry spans that keep line breaks inside a single span.
  final bool convertNewlinesToBreaks;

  // Comment to disable formatting
  static const Map<SpanType, String> defaultClassNames = {
    SpanType.bold: 'v-bold',
    SpanType.italic: 'v-italic',
    SpanType.added: 'v-added',
    SpanType.underline: 'v-underline',
    SpanType.smallCaps: 'v-small-caps',
    SpanType.superscript: 'v-superscript',
    // SpanType.strongs: 'v-strongs',
    SpanType.footnote: 'v-footnote',
    SpanType.redLetter: 'v-red-letter',
    SpanType.poetry: 'v-poetry',
    // SpanType.reference: 'v-reference',
    // SpanType.crossReference: 'v-cross-reference',
  };

  @override
  String toHtml(List<VerseSpan> spans) {
    final buffer = StringBuffer();
    for (final span in spans) {
      buffer.write(_spanToHtml(span));
    }
    return buffer.toString();
  }

  String _spanToHtml(VerseSpan span) {
    final classes = _classesFor(span.activeStyles);
    final text = _escapeText(span.text);

    final attrBuffer = StringBuffer();
    if (classes.isNotEmpty) attrBuffer.write(' class="$classes"');

    if (span.payload != null) {
      final payload = span.payload!;
      if (span.activeStyles.contains(SpanType.strongs)) {
        attrBuffer.write(' data-strongs="${_escapeAttribute(payload)}"');
      }
      if (span.activeStyles.contains(SpanType.footnote)) {
        final escaped = _escapeAttribute(payload);
        attrBuffer.write(' data-footnote="$escaped" title="$escaped"');
      }
      if (span.activeStyles.contains(SpanType.crossReference)) {
        attrBuffer.write(' data-crossref="${_escapeAttribute(payload)}"');
      }
    }

    final attributes = attrBuffer.toString();

    // Cross-references become links using a custom scheme so a WebView's
    // NavigationDelegate can intercept the tap for in-app navigation instead
    // of trying to load "verseref://..." as a real page.
    // (why not, even if in this feature it is not needed really)
    if (span.activeStyles.contains(SpanType.crossReference) &&
        span.payload != null) {
      final href = 'verseref://${Uri.encodeComponent(span.payload!)}';
      return '<a href="$href"$attributes>$text</a>';
    }

    if (attributes.isEmpty) return text;

    return '<span$attributes>$text</span>';
  }

  String _classesFor(Set<SpanType> styles) {
    return SpanType.values
        .where((type) => type != SpanType.normal && styles.contains(type))
        .map((type) => classNames[type])
        .whereType<String>()
        .join(' ');
  }

  String _escapeText(String input) {
    var out = input
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;');
    if (convertNewlinesToBreaks) {
      out = out.replaceAll('\r\n', '\n').replaceAll('\n', '<br>');
    }
    return out;
  }

  String _escapeAttribute(String input) {
    return input
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
  }
}
