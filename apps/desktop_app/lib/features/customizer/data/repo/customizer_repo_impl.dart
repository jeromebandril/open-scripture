import 'package:fpdart/fpdart.dart';
import 'package:open_scripture/core/systems/settings/settings_datasource.dart';
import 'package:open_scripture/core/systems/settings/settings_repository.dart';
import 'package:open_scripture/shared/error/failure.dart';

import '../../presentation/state/customizer_cubit.dart';

class CustomizerRepoImpl implements SettingsRepository<CustomizerState> {
  CustomizerRepoImpl({required this.localDatasource});

  final SettingsDatasource<CustomizerState> localDatasource;

  @override
  Future<Either<Failure, CustomizerState>> loadSettings() async {
    try {
      return Right(await localDatasource.loadSettings());
    } catch (e) {
      return Left(NoLocalDataFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveSettings(CustomizerState theme) async {
    try {
      return Right(await localDatasource.saveSettings(theme));
    } catch (e) {
      return Left(NoLocalDataFailure());
    }
  }
}
