import 'package:fpdart/fpdart.dart';
import 'package:open_scripture/shared/data/datasources/settings_datasource.dart';
import 'package:open_scripture/shared/domain/repositories/settings_repository.dart';
import 'package:open_scripture/shared/error/failure.dart';

import '../../domain/entities/overlay_settings.dart';

class OverlaySettingsRepoImpl implements SettingsRepository<OverlaySettings> {
  const OverlaySettingsRepoImpl({
    required this.localDatasource,
  });

  final SettingsDatasource<OverlaySettings> localDatasource;

  @override
  Future<Either<Failure, OverlaySettings>> loadSettings() async {
    try {
      return Right(await localDatasource.loadSettings());
    } catch (e) {
      return Left(UnexpectedFailure(details: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveSettings(OverlaySettings settings) async {
    try {
      return Right(localDatasource.saveSettings(settings));
    } catch (e) {
      return Left(UnexpectedFailure(details: e.toString()));
    }
  }
}
