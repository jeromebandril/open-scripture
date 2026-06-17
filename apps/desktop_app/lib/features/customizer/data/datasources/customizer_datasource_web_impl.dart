import 'dart:convert';
import 'package:open_scripture/core/engines/settings/datasource/settings_datasource_web.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_scripture/features/customizer/presentation/state/customizer_cubit.dart';

class CustomizerDatasourceWebImpl
    extends SettingsDatasourceWebBase<CustomizerState> {
  @override
  String get prefsKey => 'customizer_settings';

  @override
  Future<void> saveSettings(CustomizerState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(prefsKey, jsonEncode(state.toJson()));
  }

  @override
  Future<CustomizerState> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(prefsKey);
      if (json == null) {
        const defaults = CustomizerState();
        await saveSettings(defaults);
        return defaults;
      }
      return CustomizerState.fromJson(jsonDecode(json));
    } catch (_) {
      const defaults = CustomizerState();
      await saveSettings(defaults);
      return defaults;
    }
  }
}
