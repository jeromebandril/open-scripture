import 'dart:async';

import 'package:fpdart/fpdart.dart';

import '../../shared/error/failure.dart';
import 'datasource/settings_datasource.dart';

abstract class SettingsRepository<T> {
  T get current;
  Stream<T> get changes;
  Future<Either<Failure, T>> loadSettings();
  Future<Either<Failure, void>> saveSettings(T settings);
  Future<void> flush(); // force any pending debounced write to disk now
  Future<void> dispose(); // cancel timers, close the stream
}

class SettingsRepositoryImpl<T> implements SettingsRepository<T> {
  SettingsRepositoryImpl(
    this._datasource, {
    this.saveDebounce = const Duration(milliseconds: 800),
  }) : _cache = _datasource.defaultValue;

  final SettingsDatasource<T> _datasource;
  final Duration saveDebounce;
  T _cache;
  final _controller = StreamController<T>.broadcast();
  Timer? _writeTimer;
  T? _pendingWrite;

  @override
  T get current => _cache;

  @override
  Stream<T> get changes => _controller.stream;

  @override
  Future<Either<Failure, T>> loadSettings() async {
    try {
      final value = await _datasource.loadSettings();
      _cache = value;
      _controller.add(value);
      return Right(value);
    } catch (e) {
      return Left(UnexpectedFailure(cause: e));
    }
  }

  @override
  Future<Either<Failure, void>> saveSettings(T settings) async {
    _cache = settings;
    _controller.add(settings);

    _pendingWrite = settings;
    _writeTimer?.cancel();
    _writeTimer = Timer(saveDebounce, _flushToDisk);
    return const Right(null);
  }

  Future<void> _flushToDisk() async {
    final value = _pendingWrite;
    if (value == null) return;
    _pendingWrite = null;
    try {
      await _datasource.saveSettings(value);
    } catch (_) {
      // TODO: log error maybe?
    }
  }

  @override
  Future<void> flush() async {
    _writeTimer?.cancel();
    await _flushToDisk();
  }

  @override
  Future<void> dispose() async {
    await flush();
    await _controller.close();
  }
}
