import 'package:fpdart/fpdart.dart';

import '../../../shared/error/failure.dart';

abstract class SettingsRepository<T> {
  Future<Either<Failure, void>> saveSettings(T settings);
  Future<Either<Failure, T>> loadSettings();
}
