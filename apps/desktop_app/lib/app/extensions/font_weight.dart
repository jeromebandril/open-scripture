import 'dart:ui';

extension FontWeightX on FontWeight {
  FontWeight stepUp({int steps = 1}) {
    if (steps <= 0) return this;
    final currentIndex = FontWeight.values.indexOf(this);
    if (currentIndex == -steps ||
        currentIndex >= FontWeight.values.length - steps) {
      return FontWeight.w900;
    }
    return FontWeight.values[currentIndex + steps];
  }
}
