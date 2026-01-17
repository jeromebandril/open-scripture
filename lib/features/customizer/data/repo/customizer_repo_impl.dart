import 'package:fpdart/fpdart.dart';
import 'package:the_smyrna_bible_v2/core/error/failure.dart';
import 'package:the_smyrna_bible_v2/features/customizer/data/datasources/customizer_datasource.dart';
import 'package:the_smyrna_bible_v2/features/customizer/domain/repo/customizer_repo.dart';

import '../../presentation/cubit/customizer_cubit.dart';

class CustomizerRepoImpl implements CustomizerRepo {
  CustomizerRepoImpl({required this.localDatasource});

  final CustomizerDatasource localDatasource;

  @override
  Future<Either<Failure, CustomizerState>> loadTheme() async {
    try {
      return Right(await localDatasource.loadTheme());
    } catch (e) {
      return Left(NoLocalDataFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveTheme(CustomizerState theme) async {
    try {
      return Right(await localDatasource.saveTheme(theme));
    } catch (e) {
      return Left(NoLocalDataFailure());
    }
  }
}
