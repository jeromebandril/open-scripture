import 'package:flutter/material.dart';

enum GradientType {
  radial,
  complex,
}

enum GradientPreset {
  blue(
    name: 'Blue',
    type: GradientType.complex,
    colors: [
      Color(0xFF38BDF8),
      Color(0xFF2563EB),
      Color(0xFF0B1020),
    ],
  ),
  purple(
    name: 'Purple',
    type: GradientType.complex,
    colors: [
      Color(0xFFE879F9),
      Color(0xFF7C3AED),
      Color(0xFF140D25),
    ],
  ),
  orange(
    name: 'Orange',
    type: GradientType.complex,
    colors: [
      Color(0xFFFDBA74),
      Color(0xFFF97316),
      Color(0xFF21110B),
    ],
  ),
  green(
    name: 'Green',
    type: GradientType.complex,
    colors: [
      Color(0xFF6EE7B7),
      Color(0xFF059669),
      Color(0xFF071B16),
    ],
  ),
  radialBlue(
    name: 'Radial Blue',
    type: GradientType.radial,
    colors: [
      Color(0xFF38BDF8),
      Color(0xFF2563EB),
      Color(0xFF1E3A8A),
      Color(0xFF0F172A),
    ],
  ),
  radialPurple(
    name: 'Radial Purple',
    type: GradientType.radial,
    colors: [
      Color(0xFFC084FC),
      Color(0xFF9333EA),
      Color(0xFF581C87),
      Color(0xFF1A102E),
    ],
  ),
  radialOrange(
    name: 'Radial Orange',
    type: GradientType.radial,
    colors: [
      Color(0xFFFDBA74),
      Color(0xFFEA580C),
      Color(0xFF9A3412),
      Color(0xFF431407),
    ],
  ),
  radialGreen(
    name: 'Radial Green',
    type: GradientType.radial,
    colors: [
      Color(0xFF86EFAC),
      Color(0xFF16A34A),
      Color(0xFF166534),
      Color(0xFF052E16),
    ],
  );

  final String name;
  final GradientType type;
  final List<Color> colors;

  const GradientPreset({
    required this.name,
    required this.type,
    required this.colors,
  });

  RadialGradient get gradient {
    assert(type == GradientType.radial);

    return RadialGradient(
      center: const Alignment(-0.8, -0.9),
      radius: 1.4,
      colors: colors,
      stops: const [
        0.0,
        0.35,
        0.7,
        1.0,
      ],
    );
  }

  static GradientPreset? fromName(String name) {
    for (final preset in values) {
      if (preset.name.toLowerCase() == name.trim().toLowerCase()) {
        return preset;
      }
    }

    return null;
  }
}
