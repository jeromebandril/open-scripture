import 'package:fpdart/fpdart.dart';

import '../../../../core/systems/settings/settings_datasource.dart';
import '../../../../core/systems/settings/settings_repository.dart';
import '../../../../shared/error/failure.dart';
import '../../domain/entities/remote_controller_settings.dart';

class RemoteControllerSettingsRepoImpl
    implements SettingsRepository<RemoteControllerSettings> {
  const RemoteControllerSettingsRepoImpl({required this.localDatasource});

  final SettingsDatasource<RemoteControllerSettings> localDatasource;

  @override
  Future<Either<Failure, RemoteControllerSettings>> loadSettings() async {
    try {
      return Right(await localDatasource.loadSettings());
    } catch (e) {
      return Left(UnexpectedFailure(details: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveSettings(
      RemoteControllerSettings settings) async {
    try {
      return Right(await localDatasource.saveSettings(settings));
    } catch (e) {
      return Left(UnexpectedFailure(details: e.toString()));
    }
  }
}
