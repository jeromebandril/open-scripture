import 'dart:ui';

class ColorsUtil {
  ColorsUtil._();

  static String colorToHex(Color c) {
    return c.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase();
  }

  static int parseHex(String input) {
    var hex = input.trim().toUpperCase();

    // Remove prefixes
    if (hex.startsWith('#')) {
      hex = hex.substring(1);
    } else if (hex.startsWith('0X')) {
      hex = hex.substring(2);
    }

    // If RGB, add full alpha
    if (hex.length == 6) {
      hex = 'FF$hex';
    }

    if (hex.length != 8) {
      throw FormatException('Invalid color hex: $input');
    }

    return int.parse(hex, radix: 16);
  }
}
