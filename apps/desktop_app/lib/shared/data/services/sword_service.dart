import '../../../core/engines/settings/settings_repository.dart';
import '../../../core/infrastructure/event_bus/install_notifier.dart';
import '../../../core/sword/sword_bridge.dart';
import '../../../features/sword/settings/sword_engine_settings.dart';

class SwordService {
  SwordService({
    required SettingsRepository<SwordEngineSettings> settingsRepo,
    required InstallNotifier installNotifier,
  })  : _installNotifier = installNotifier,
        _settingsRepo = settingsRepo;

  final SettingsRepository<SwordEngineSettings> _settingsRepo;
  final InstallNotifier _installNotifier;
  SwordBridge? _bridge;

  bool get isInitialized => _bridge != null;

  Future<String> _resolveModulesPath() async {
    final result = await _settingsRepo.loadSettings();
    return result.match(
      (failure) =>
          throw Exception('Could not load Sword engine settings: $failure'),
      (settings) => settings.modulesPath,
    );
  }

  Future<SwordBridge> get instance async {
    if (isInitialized) return _bridge!;
    final modulesPath = await _resolveModulesPath();
    _bridge = SwordBridge.create(modulesPath);
    if (_bridge == null) {
      throw Exception('Failed to initialize native Sword engine.');
    }
    return _bridge!;
  }

  void shutdown() {
    _bridge?.shutdown();
    _bridge = null;
  }

  Future<void> restart() async {
    final modulesPath = await _resolveModulesPath();
    _bridge?.shutdown();
    _bridge = SwordBridge.create(modulesPath);
    if (!isInitialized) {
      throw Exception('Failed to restart native Sword engine.');
    }
    _installNotifier.refreshInstalledList();
  }
}
