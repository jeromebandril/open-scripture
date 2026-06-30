import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'settings_datasource.dart';

abstract class SettingsDatasourceWebBase<T> implements SettingsDatasource<T> {
  String get prefsKey;

  @override
  Future<void> saveSettings(T settings) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode((settings as dynamic).toJson());
    await prefs.setString(prefsKey, json);
  }
}
