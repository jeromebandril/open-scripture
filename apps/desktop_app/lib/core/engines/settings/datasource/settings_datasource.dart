abstract class SettingsDatasource<T> {
  T get defaultValue;
  Future<void> saveSettings(T settings);
  Future<T> loadSettings();
}
