import 'package:fpdart/fpdart.dart';
import '../../../core/engines/settings/settings_repository.dart';
import '../../../core/infrastructure/event_bus/install_notifier.dart';
import '../../../core/sword/sword_bridge.dart';
import '../../../features/bible_importer/domain/entities/bible_importer_settings.dart';
import '../../domain/services/bible_importer_settings_service.dart';
import '../../error/failure.dart';

class BibleImporterSettingsServiceImpl implements BibleImporterSettingsService {
  BibleImporterSettingsServiceImpl({
    required SettingsRepository<BibleImporterSettings> settingsRepo,
    required SwordBridge bridge,
    required InstallNotifier installNotifier,
  })  : _installNotifier = installNotifier,
        _settingsRepo = settingsRepo,
        _bridge = bridge;

  final SettingsRepository<BibleImporterSettings> _settingsRepo;
  final SwordBridge _bridge;
  final InstallNotifier _installNotifier;
  late BibleImporterSettings _current;

  @override
  BibleImporterSettings get current => _current;

  @override
  Future<void> initialize() async {
    final result = await _settingsRepo.loadSettings();
    _current = result.fold(
      (_) => const BibleImporterSettings(swordInstallationPath: ''),
      (settings) => settings,
    );
    _bridge.init(_current.swordInstallationPath);
  }

  @override
  Future<Either<Failure, void>> updatePath(String newPath) async {
    final updated = _current.copyWith(swordInstallationPath: newPath);
    final result = await _settingsRepo.saveSettings(updated);
    return result.fold(
      (failure) => Left(failure),
      (_) {
        _current = updated;
        _bridge.shutdown();
        _bridge.init(newPath);
        _installNotifier.refreshInstalledList();
        return const Right(null);
      },
    );
  }
}
