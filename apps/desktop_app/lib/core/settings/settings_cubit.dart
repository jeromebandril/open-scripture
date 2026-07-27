import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'settings_repository.dart';

class SettingsCubit<T> extends Cubit<T> {
  SettingsCubit(this.repo) : super(repo.current) {
    _sub = repo.changes.listen(emit);
  }

  final SettingsRepository<T> repo;
  late final StreamSubscription<T> _sub;

  Future<void> update(
    T Function(T current) update,
  ) {
    return repo.saveSettings(update(state));
  }

  @override
  Future<void> close() async {
    await _sub.cancel();
    await repo.flush();
    return super.close();
  }
}
