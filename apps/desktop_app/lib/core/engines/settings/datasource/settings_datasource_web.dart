import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

abstract class SettingsDatasource<T> {
  String get prefsKey;

  Future<void> saveSettings(T settings) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode((settings as dynamic).toJson());
    await prefs.setString(prefsKey, json);
  }

  Future<T> loadSettings();
}
