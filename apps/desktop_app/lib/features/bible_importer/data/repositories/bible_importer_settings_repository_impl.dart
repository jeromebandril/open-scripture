import 'package:fpdart/fpdart.dart';
import 'package:open_scripture/core/engines/settings/datasource/settings_datasource.dart';
import 'package:open_scripture/core/engines/settings/settings_repository.dart';
import 'package:open_scripture/features/bible_importer/domain/entities/bible_importer_settings.dart';
import 'package:open_scripture/shared/error/failure.dart';

class BibleImporterSettingsRepositoryImpl
    implements SettingsRepository<BibleImporterSettings> {
  final SettingsDatasource<BibleImporterSettings> _datasource;

  BibleImporterSettingsRepositoryImpl(
      {required SettingsDatasource<BibleImporterSettings> datasource})
      : _datasource = datasource;

  @override
  Future<Either<Failure, BibleImporterSettings>> loadSettings() async {
    final result = await _datasource.loadSettings();
    return Right(result);
  }

  @override
  Future<Either<Failure, void>> saveSettings(
      BibleImporterSettings settings) async {
    try {
      await _datasource.saveSettings(settings);
      return Right(null);
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}
