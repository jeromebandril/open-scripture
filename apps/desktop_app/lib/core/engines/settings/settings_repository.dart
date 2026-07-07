import 'package:fpdart/fpdart.dart';

import '../../../shared/error/failure.dart';
import 'datasource/settings_datasource.dart';

abstract class SettingsRepository<T> {
  Future<Either<Failure, void>> saveSettings(T settings);
  Future<Either<Failure, T>> loadSettings();
}

class SettingsRepositoryImpl<T> implements SettingsRepository<T> {
  SettingsRepositoryImpl(this._datasource);
  final SettingsDatasource<T> _datasource;

  T? _cache;

  @override
  Future<Either<Failure, T>> loadSettings() async {
    final cached = _cache;
    if (cached != null) return Right(cached);
    try {
      final value = await _datasource.loadSettings();
      _cache = value;
      return Right(value);
    } catch (e) {
      return Left(UnknownFailure(details: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveSettings(T settings) async {
    try {
      await _datasource.saveSettings(settings);
      _cache = settings;
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(details: e.toString()));
    }
  }
}
