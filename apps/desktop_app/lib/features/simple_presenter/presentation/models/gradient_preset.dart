import 'package:flutter/material.dart';

enum GradientPreset {
  blue(
    name: 'Blue',
    colors: [
      Color(0xFF38BDF8),
      Color(0xFF2563EB),
      Color(0xFF1E3A8A),
      Color(0xFF0F172A),
    ],
  ),
  purple(
    name: 'Purple',
    colors: [
      Color(0xFFC084FC),
      Color(0xFF9333EA),
      Color(0xFF581C87),
      Color(0xFF1A102E),
    ],
  ),
  orange(
    name: 'Orange',
    colors: [
      Color(0xFFFDBA74),
      Color(0xFFEA580C),
      Color(0xFF9A3412),
      Color(0xFF431407),
    ],
  ),
  green(
    name: 'Green',
    colors: [
      Color(0xFF86EFAC),
      Color(0xFF16A34A),
      Color(0xFF166534),
      Color(0xFF052E16),
    ],
  );

  final String name;
  final List<Color> colors;

  const GradientPreset({
    required this.name,
    required this.colors,
  });

  RadialGradient get gradient => RadialGradient(
        center: const Alignment(-0.8, -0.9),
        radius: 1.4,
        colors: colors,
        stops: const [0.0, 0.35, 0.7, 1.0],
      );

  static GradientPreset? fromName(String name) {
    for (final preset in values) {
      if (preset.name.toLowerCase() == name.trim().toLowerCase()) {
        return preset;
      }
    }

    return null;
  }
}
