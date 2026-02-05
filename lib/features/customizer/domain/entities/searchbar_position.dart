enum SearchbarPosition { left, center }

extension SearchbarPositionWire on SearchbarPosition {
  String get wire {
    switch (this) {
      case SearchbarPosition.left:
        return 'left';
      case SearchbarPosition.center:
        return 'center';
    }
  }

  static fromWire(String value) {
    switch (value) {
      case 'left':
        return SearchbarPosition.left;
      case 'center':
        return SearchbarPosition.center;
      default:
        return SearchbarPosition.left;
    }
  }
}
