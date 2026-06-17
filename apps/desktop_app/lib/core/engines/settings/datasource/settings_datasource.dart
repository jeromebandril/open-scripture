abstract class SettingsDatasource<T> {
  Future<void> saveSettings(T settings);
  Future<T> loadSettings();
}
