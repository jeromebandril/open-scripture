import 'package:fpdart/fpdart.dart';
import 'package:open_scripture/features/customizer/presentation/cubit/customizer_cubit.dart';

import '../../../../core/error/failure.dart';

abstract class CustomizerRepo {
  Future<Either<Failure, void>> saveTheme(CustomizerState theme);
  Future<Either<Failure, CustomizerState>> loadTheme();
}
