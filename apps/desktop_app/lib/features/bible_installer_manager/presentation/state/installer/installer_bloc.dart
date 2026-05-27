import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_scripture/features/bible_installer_manager/domain/repositories/bible_manager_repository.dart';

import '../../../../../core/infrastructure/event_bus/install_notifier.dart';

part 'installer_event.dart';
part 'installer_state.dart';

class InstallerBloc extends Bloc<InstallerEvent, InstallerState> {
  final BibleManagerRepository _repo;
  final InstallNotifier _notifier;

  InstallerBloc({
    required BibleManagerRepository repository,
    required InstallNotifier notifier,
  })  : _repo = repository,
        _notifier = notifier,
        super(const InstallerState()) {
    // on<InstalledBiblesLoad>(_onLoad);
    on<InstalledBiblesUninstall>(_onUninstall);
    on<InstalledBiblesSelect>(_setSelected);
  }

  Future<void> _onUninstall(
    InstalledBiblesUninstall event,
    Emitter<InstallerState> emit,
  ) async {
    final result = await _repo.uninstallBible(event.id);

    result.fold(
      (f) => emit(state.copyWith(
        status: () => InstalledBiblesStatus.error,
        errorMessage: () => f.toString(),
      )),
      (_) {
        _notifier.refreshInstalledList();
        // final updatedList = List<BibleMeta>.from(state.installedBibles);
        // updatedList.removeWhere((b) => b.extId == event.id);
        emit(state.copyWith(
          status: () => InstalledBiblesStatus.loaded,
        ));
      },
    );
  }

  Future<void> _setSelected(
    InstalledBiblesSelect event,
    Emitter<InstallerState> emit,
  ) async =>
      emit(state.copyWith(selectedBibleId: () => event.selectedId));
}
