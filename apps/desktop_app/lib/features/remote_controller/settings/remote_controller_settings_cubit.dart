import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../core/engines/settings/settings_repository.dart';
import 'remote_controller_settings.dart';

class RemoteControllerSettingsCubit extends Cubit<RemoteControllerSettings> {
  RemoteControllerSettingsCubit({required this.repo}) : super(repo.current) {
    _sub = repo.changes.listen(emit);
  }

  final SettingsRepository<RemoteControllerSettings> repo;
  late final StreamSubscription<RemoteControllerSettings> _sub;

  void updateSettings(
    RemoteControllerSettings Function(RemoteControllerSettings) update,
  ) {
    repo.saveSettings(update(state));
  }

  @override
  Future<void> close() async {
    await _sub.cancel();
    await repo.flush();
    await super.close();
  }
}
