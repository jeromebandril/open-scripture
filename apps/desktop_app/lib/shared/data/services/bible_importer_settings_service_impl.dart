import 'package:fpdart/fpdart.dart';
import 'package:open_scripture/core/engines/settings/settings_repository.dart';
import 'package:open_scripture/core/infrastructure/event_bus/install_notifier.dart';
import 'package:open_scripture/core/sword/sword_bridge.dart';
import 'package:open_scripture/features/bible_importer/domain/entities/bible_importer_settings.dart';
import 'package:open_scripture/shared/domain/services/bible_importer_settings_service.dart';
import 'package:open_scripture/shared/error/failure.dart';

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
