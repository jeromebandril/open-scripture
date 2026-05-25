import 'dart:convert';
import 'dart:io';

import 'package:open_scripture/core/engines/settings/settings_datasource.dart';

import '../../domain/entities/overlay_settings.dart';

class OverlaySettingsDatasourceImpl
    extends SettingsDatasource<OverlaySettings> {
  OverlaySettingsDatasourceImpl({this.fileName = 'overlay_settings.json'});

  final String fileName;

  @override
  Future<OverlaySettings> loadSettings() async {
    try {
      final file = await settingsFile(fileName: fileName);

      if (!await file.exists()) {
        const defaults = OverlaySettings();
        await saveSettings(defaults);
        return defaults;
      }

      try {
        final content = await file.readAsString();
        final decoded = jsonDecode(content);
        if (decoded is! Map<String, dynamic>) {
          throw const FormatException('settings.json root is not an object');
        }
        return OverlaySettings.fromJson(decoded);
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
        const defaults = OverlaySettings();
        await saveSettings(defaults);
        return defaults;
      }
    } catch (e) {
      throw Exception('Failed to load overlay settings');
    }
  }

  @override
  Future<void> saveSettings(OverlaySettings settings) async {
    try {
      final file = await settingsFile(fileName: fileName);
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
      throw Exception('Failed to save overlay settings');
    }
  }
}
