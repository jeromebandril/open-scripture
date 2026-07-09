enum PresentationVerseNumberStyle {
  simple,
  boxed,
}

extension PresentationVerseNumberStyleWire on PresentationVerseNumberStyle {
  String get wire {
    switch (this) {
      case PresentationVerseNumberStyle.simple:
        return 'default';
      case PresentationVerseNumberStyle.boxed:
        return 'boxed';
    }
  }

  static PresentationVerseNumberStyle fromWire(String value) {
    switch (value) {
      case 'default':
        return PresentationVerseNumberStyle.simple;
      case 'boxed':
        return PresentationVerseNumberStyle.boxed;
      default:
        return PresentationVerseNumberStyle.simple;
    }
  }
}
