import 'dart:convert';
import 'dart:io';

import 'package:open_scripture/core/engines/settings/datasource/settings_datasource_desktop.dart';

import '../../domain/entities/remote_controller_settings.dart';

class RemoteControllerSettingsDatasource
    extends SettingsDatasourceDesktopBase<RemoteControllerSettings> {
  final String _fileName = 'remote_controller_settings.json';

  @override
  Future<RemoteControllerSettings> loadSettings() async {
    try {
      final file = await settingsFile(fileName: _fileName);

      if (!await file.exists()) {
        const defaults = RemoteControllerSettings();
        await saveSettings(defaults);
        return defaults;
      }

      try {
        final content = await file.readAsString();
        final decoded = jsonDecode(content);
        if (decoded is! Map<String, dynamic>) {
          throw const FormatException('settings.json root is not an object');
        }
        return RemoteControllerSettings.fromJson(decoded);
      } catch (e) {
        print(e);
        // Backup the corrupted file for debugging
        final backupPath =
            '${file.path}.corrupt.${DateTime.now().millisecondsSinceEpoch}';
        try {
          await file.rename(backupPath);
        } catch (_) {
          // If rename fails (e.g., permissions), ignore and proceed with defaults
        }
        const defaults = RemoteControllerSettings();
        await saveSettings(defaults);
        return defaults;
      }
    } catch (e) {
      throw Exception('Failed to load remote controller settings');
    }
  }

  @override
  Future<void> saveSettings(RemoteControllerSettings settings) async {
    try {
      final file = await settingsFile(fileName: _fileName);
      final tmp = File('${file.path}.tmp');

      final jsonString =
          const JsonEncoder.withIndent('  ').convert(settings.toJson());

      // Write temp
      await tmp.writeAsString(jsonString, flush: true);

      // Replace target atomically where possible
      if (await file.exists()) {
        await file.delete();
      }
      await tmp.rename(file.path);
    } catch (e) {
      throw Exception('Failed to save remote controller settings');
    }
  }
}
