enum PresentationVerseNumberStyle {
  normal,
  boxed,
}

extension PresentationVerseNumberStyleWire on PresentationVerseNumberStyle {
  String get wire {
    switch (this) {
      case PresentationVerseNumberStyle.normal:
        return 'normal';
      case PresentationVerseNumberStyle.boxed:
        return 'boxed';
    }
  }

  static PresentationVerseNumberStyle fromWire(String value) {
    switch (value) {
      case 'normal':
        return PresentationVerseNumberStyle.normal;
      case 'boxed':
        return PresentationVerseNumberStyle.boxed;
      default:
        return PresentationVerseNumberStyle.normal;
    }
  }
}
