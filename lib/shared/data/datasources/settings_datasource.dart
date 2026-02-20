abstract class SettingsDatasource<T> {
  /// Saves settings locally.
  ///
  /// Throws a [InstallationException] if it fails
  Future<void> saveSettings(T settings);

  /// Load settings.
  ///
  /// Throws a [InstallationException] if it fails
  Future<T> loadSettings();
}
