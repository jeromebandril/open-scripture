import '../../../../shared/domain/entities/verse.dart';

abstract class VerseHtmlFormatter {
  /// Converts [spans] into a single HTML fragment (no `<html>`/`<body>` wrapper)
  String toHtml(List<VerseSpan> spans);
}
