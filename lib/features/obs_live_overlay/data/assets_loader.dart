import 'package:flutter/services.dart' show rootBundle;

Future<String> loadOverlayAsset(String assetPath) {
  return rootBundle.loadString(assetPath);
}
