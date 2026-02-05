enum HighlightRenderMode {
  fullRefWithColor;
}

extension HighlightRenderModeWire on HighlightRenderMode {
  String get wire {
    switch (this) {
      case HighlightRenderMode.fullRefWithColor:
        return 'fullRefWithColor';
    }
  }

  static HighlightRenderMode fromWire(String value) {
    switch (value) {
      case 'fullRefWithColor':
        return HighlightRenderMode.fullRefWithColor;
      default:
        return HighlightRenderMode.fullRefWithColor;
    }
  }
}
