enum InlineVerseNumberStyle {
  simple,
  boxed,
}

extension InlineVerseNumberStyleWire on InlineVerseNumberStyle {
  String get wire {
    switch (this) {
      case InlineVerseNumberStyle.simple:
        return 'default';
      case InlineVerseNumberStyle.boxed:
        return 'boxed';
    }
  }

  static InlineVerseNumberStyle fromWire(String value) {
    switch (value) {
      case 'default':
        return InlineVerseNumberStyle.simple;
      case 'boxed':
        return InlineVerseNumberStyle.boxed;
      default:
        return InlineVerseNumberStyle.simple;
    }
  }
}
