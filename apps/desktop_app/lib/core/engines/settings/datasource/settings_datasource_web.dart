import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'settings_datasource.dart';

class SettingsDatasourceWeb<T> implements SettingsDatasource<T> {
  SettingsDatasourceWeb({
    required this.prefsKey,
    required this.fromJson,
    required this.toJson,
    required this.defaultValue,
    this.sanitize,
  });

  final String prefsKey;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;
  final T defaultValue;
  final T Function(T)? sanitize;

  @override
  Future<T> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(prefsKey);

      if (raw == null) {
        await saveSettings(defaultValue);
        return defaultValue;
      }

      T value;
      try {
        final decoded = jsonDecode(raw);
        if (decoded is! Map<String, dynamic>) {
          throw const FormatException('root is not an object');
        }
        value = fromJson(decoded);
      } catch (_) {
        await saveSettings(defaultValue);
        return defaultValue;
      }

      final sanitized = sanitize?.call(value) ?? value;
      if (sanitized != value) {
        await saveSettings(sanitized);
      }
      return sanitized;
    } catch (e) {
      throw Exception('Failed to load $prefsKey: $e');
    }
  }

  @override
  Future<void> saveSettings(T settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(toJson(settings));
      await prefs.setString(prefsKey, jsonString);
    } catch (e) {
      throw Exception('Failed to save $prefsKey: $e');
    }
  }
}
