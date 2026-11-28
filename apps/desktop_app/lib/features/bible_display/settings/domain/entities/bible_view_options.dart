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

enum TextCase {
  sentenceCase,
  uppercase;

  String get label => switch (this) {
        TextCase.sentenceCase => 'Sentence case',
        TextCase.uppercase => 'UPPER CASE',
      };
}

enum UiSize {
  normal,
  small,
  compact;

  /// Equivalent offset values for setting verse reference
  /// font size in relative to the verse text fontsize
  double get refSizeOffset => switch (this) {
        UiSize.normal => 0,
        UiSize.small => -1,
        UiSize.compact => -2,
      };
}
