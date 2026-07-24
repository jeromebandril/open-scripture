import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class OverlayFilesystem {
  static const _assetBase = 'lib/features/obs_live_overlay/overlay_web';

  static const List<String> _files = [
    'overlay.html',
    'overlay.js',
    'overlay.css',
  ];

  Future<Directory> _getOverlayDir() async {
    final supportDir = await getApplicationSupportDirectory();
    return Directory(p.join(supportDir.path, 'overlay_web'));
  }

  /// Copies bundled assets to disk if missing (e.g. first run).
  Future<void> ensureExtracted() async {
    final dir = await _getOverlayDir();
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    for (final name in _files) {
      final dst = File(p.join(dir.path, name));
      if (await dst.exists()) continue;

      final assetPath = '$_assetBase/$name';
      final content = await rootBundle.loadString(assetPath);
      await dst.writeAsString(content);
    }
  }

  /// Overwrites disk files with bundled defaults.
  Future<void> resetToDefaults() async {
    final dir = await _getOverlayDir();
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    for (final name in _files) {
      final assetPath = '$_assetBase/$name';
      final content = await rootBundle.loadString(assetPath);
      await File(p.join(dir.path, name)).writeAsString(content);
    }
  }

  Future<String> readOverlayFile(String fileName) async {
    final dir = await _getOverlayDir();
    final file = File(p.join(dir.path, fileName));

    if (await file.exists()) {
      return file.readAsString();
    }

    return rootBundle.loadString('$_assetBase/$fileName');
  }
}
