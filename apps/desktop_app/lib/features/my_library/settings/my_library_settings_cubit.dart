import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/settings/settings_repository.dart';
import 'my_library_settings.dart';

class MyLibrarySettingsCubit extends Cubit<MyLibrarySettings> {
  MyLibrarySettingsCubit({required this.repo}) : super(repo.current) {
    _sub = repo.changes.listen(emit);
  }

  final SettingsRepository<MyLibrarySettings> repo;
  late final StreamSubscription<MyLibrarySettings> _sub;

  void updateSettings(MyLibrarySettings Function(MyLibrarySettings) update) {
    repo.saveSettings(update(state));
  }

  @override
  Future<void> close() async {
    await _sub.cancel();
    await repo.flush();
    await super.close();
  }
}
