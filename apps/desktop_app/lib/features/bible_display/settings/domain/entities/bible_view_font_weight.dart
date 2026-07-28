enum BibleViewFontWeight {
  thin,
  extraLight,
  light,
  regular,
  medium,
  semiBold,
  bold,
  extraBold,
  black,
}

extension AppFontWeightWire on BibleViewFontWeight {
  String get wire {
    switch (this) {
      case BibleViewFontWeight.thin:
        return 'thin';
      case BibleViewFontWeight.extraLight:
        return 'extraLight';
      case BibleViewFontWeight.light:
        return 'light';
      case BibleViewFontWeight.regular:
        return 'regular';
      case BibleViewFontWeight.medium:
        return 'medium';
      case BibleViewFontWeight.semiBold:
        return 'semiBold';
      case BibleViewFontWeight.bold:
        return 'bold';
      case BibleViewFontWeight.extraBold:
        return 'extraBold';
      case BibleViewFontWeight.black:
        return 'black';
    }
  }

  static BibleViewFontWeight fromWire(String value) {
    switch (value) {
      case 'thin':
        return BibleViewFontWeight.thin;
      case 'extraLight':
        return BibleViewFontWeight.extraLight;
      case 'light':
        return BibleViewFontWeight.light;
      case 'regular':
        return BibleViewFontWeight.regular;
      case 'medium':
        return BibleViewFontWeight.medium;
      case 'semiBold':
        return BibleViewFontWeight.semiBold;
      case 'bold':
        return BibleViewFontWeight.bold;
      case 'extraBold':
        return BibleViewFontWeight.extraBold;
      case 'black':
        return BibleViewFontWeight.black;
      default:
        return BibleViewFontWeight.regular;
    }
  }
}
