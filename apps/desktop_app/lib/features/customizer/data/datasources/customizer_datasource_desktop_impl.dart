import 'dart:convert';
import 'dart:io';

import 'package:open_scripture/core/engines/settings/datasource/settings_datasource_desktop.dart';
import 'package:open_scripture/features/customizer/presentation/state/customizer_cubit.dart';

class CustomizerDatasourceDesktopImpl
    extends SettingsDatasourceDesktopBase<CustomizerState> {
  final String fileName = 'settings.json';

  @override
  Future<void> saveSettings(CustomizerState theme) async {
    try {
      final file = await settingsFile(fileName: fileName);
      final tmp = File('${file.path}.tmp');

      final jsonString =
          const JsonEncoder.withIndent('  ').convert(theme.toJson());

      // Write temp
      await tmp.writeAsString(jsonString, flush: true);

      // Replace target atomically where possible
      if (await file.exists()) {
        await file.delete();
      }
      await tmp.rename(file.path);
    } catch (e) {
      throw Exception();
    }
  }

  /// Load settings. If missing, returns defaults and writes them once.
  /// If corrupted, renames the bad file and returns defaults.
  @override
  Future<CustomizerState> loadSettings() async {
    try {
      final file = await settingsFile(fileName: fileName);

      if (!await file.exists()) {
        const defaults = CustomizerState();
        await saveSettings(defaults);
        return defaults;
      }

      try {
        final content = await file.readAsString();
        final decoded = jsonDecode(content);
        if (decoded is! Map<String, dynamic>) {
          throw const FormatException('settings.json root is not an object');
        }
        return CustomizerState.fromJson(decoded);
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
        const defaults = CustomizerState();
        await saveSettings(defaults);
        return defaults;
      }
    } catch (e) {
      print(e);
      throw Exception();
    }
  }
}
