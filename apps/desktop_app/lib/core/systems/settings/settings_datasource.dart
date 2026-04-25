import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

abstract class SettingsDatasource<T> {
  Future<File> settingsFile({required String fileName}) async {
    final dir = await getApplicationSupportDirectory();
    final settingsDir = Directory(p.join(dir.path, 'settings'));
    if (!await settingsDir.exists()) {
      await settingsDir.create(recursive: true);
    }
    return File(p.join(settingsDir.path, fileName));
  }

  /// Saves settings locally.
  ///
  /// Throws a [InstallationException] if it fails
  Future<void> saveSettings(T settings);

  /// Load settings.
  ///
  /// Throws a [InstallationException] if it fails
  Future<T> loadSettings();
}
