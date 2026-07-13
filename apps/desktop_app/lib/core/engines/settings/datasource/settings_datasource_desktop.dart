import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'settings_datasource.dart';

class SettingsDatasourceDesktop<T> implements SettingsDatasource<T> {
  SettingsDatasourceDesktop({
    required this.fileName,
    required this.fromJson,
    required this.toJson,
    required this.defaultValue,
  });

  final String fileName;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;
  final T defaultValue;

  Future<File> _resolveFile() async {
    final dir = await getApplicationSupportDirectory();
    final settingsDir = Directory(p.join(dir.path, 'settings'));
    if (!await settingsDir.exists()) {
      await settingsDir.create(recursive: true);
    }
    return File(p.join(settingsDir.path, fileName));
  }

  @override
  Future<T> loadSettings() async {
    try {
      final file = await _resolveFile();
      if (!await file.exists()) {
        await saveSettings(defaultValue);
        return defaultValue;
      }

      try {
        final decoded = jsonDecode(await file.readAsString());
        if (decoded is! Map<String, dynamic>) {
          throw const FormatException('root is not an object');
        }
        return fromJson(decoded);
      } catch (_) {
        await _backupCorrupted(file);
        await saveSettings(defaultValue);
        return defaultValue;
      }
    } catch (e) {
      throw Exception('Failed to load $fileName');
    }
  }

  @override
  Future<void> saveSettings(T value) async {
    try {
      final file = await _resolveFile();
      final tmp = File('${file.path}.tmp');
      final jsonString =
          const JsonEncoder.withIndent('  ').convert(toJson(value));

      await tmp.writeAsString(jsonString, flush: true);
      if (await file.exists()) {
        await file.delete();
      }
      await tmp.rename(file.path);
    } catch (e) {
      throw Exception('Failed to save $fileName');
    }
  }

  Future<void> _backupCorrupted(File file) async {
    final backupPath =
        '${file.path}.corrupt.${DateTime.now().millisecondsSinceEpoch}';
    try {
      await file.rename(backupPath);
    } catch (_) {}
  }
}
