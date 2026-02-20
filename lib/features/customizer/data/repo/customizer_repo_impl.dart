import 'package:fpdart/fpdart.dart';
import 'package:open_scripture/shared/data/datasources/settings_datasource.dart';
import 'package:open_scripture/shared/error/failure.dart';
import 'package:open_scripture/features/customizer/domain/repo/customizer_repo.dart';

import '../../presentation/cubit/customizer_cubit.dart';

class CustomizerRepoImpl implements CustomizerRepo {
  CustomizerRepoImpl({required this.localDatasource});

  final SettingsDatasource<CustomizerState> localDatasource;

  @override
  Future<Either<Failure, CustomizerState>> loadTheme() async {
    try {
      return Right(await localDatasource.loadSettings());
    } catch (e) {
      return Left(NoLocalDataFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveTheme(CustomizerState theme) async {
    try {
      return Right(await localDatasource.saveSettings(theme));
    } catch (e) {
      return Left(NoLocalDataFailure());
    }
  }
}
