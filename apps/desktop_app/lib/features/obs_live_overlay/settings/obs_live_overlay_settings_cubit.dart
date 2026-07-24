import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../core/settings/settings_repository.dart';
import 'overlay_settings.dart';

class ObsLiveOverlaySettingsCubit extends Cubit<OverlaySettings> {
  ObsLiveOverlaySettingsCubit({required this.repo}) : super(repo.current) {
    _sub = repo.changes.listen(emit);
  }

  final SettingsRepository<OverlaySettings> repo;
  late final StreamSubscription<OverlaySettings> _sub;

  void updateSettings(OverlaySettings Function(OverlaySettings) update) {
    repo.saveSettings(update(state));
  }

  @override
  Future<void> close() async {
    await _sub.cancel();
    await repo.flush();
    await super.close();
  }
}
