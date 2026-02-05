enum AppTextAlignment { left, center }

extension AppTextAlignmentWire on AppTextAlignment {
  String get wire {
    switch (this) {
      case AppTextAlignment.left:
        return 'left';
      case AppTextAlignment.center:
        return 'center';
    }
  }

  static AppTextAlignment fromWire(String value) {
    switch (value) {
      case 'left':
        return AppTextAlignment.left;
      case 'center':
        return AppTextAlignment.center;
      default:
        return AppTextAlignment.left;
    }
  }
}
