enum InlineVerseNumberStyle {
  simple,
  boxed,
}

enum HighlightRenderMode {
  shortRefWithColor;

  String get label => switch (this) {
        HighlightRenderMode.shortRefWithColor => 'Short ref with color change',
      };
}
