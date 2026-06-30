import 'package:fpdart/fpdart.dart';

import '../../../../core/engines/settings/datasource/settings_datasource.dart';
import '../../../../core/engines/settings/settings_repository.dart';
import '../../../../shared/error/failure.dart';
import '../../domain/entities/bible_importer_settings.dart';

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
