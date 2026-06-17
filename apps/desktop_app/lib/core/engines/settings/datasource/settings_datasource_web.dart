import 'package:open_scripture/core/engines/settings/datasource/settings_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

abstract class SettingsDatasourceWebBase<T> implements SettingsDatasource<T> {
  String get prefsKey;

  @override
  Future<void> saveSettings(T settings) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode((settings as dynamic).toJson());
    await prefs.setString(prefsKey, json);
  }
}
