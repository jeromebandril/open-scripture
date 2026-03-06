import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_scripture/shared/domain/entities/bible_meta.dart';
import 'package:open_scripture/features/bible_installer_manager/domain/repositories/bible_manager_repository.dart';

import '../../../../../shared/presentation/notifiers/install_notifier.dart';

part 'installed_bibles_event.dart';
part 'installed_bibles_state.dart';

/// This bloc manages the installed translations:
///
/// - View all locally installed translations
/// - Uninstall translations
///
class InstalledBiblesBloc
    extends Bloc<InstalledBiblesEvent, InstalledBiblesState> {
  final BibleManagerRepository repository;

  late final StreamSubscription _sub;

  InstalledBiblesBloc({
    required this.repository,
    required InstallNotifier notifier,
  }) : super(const InstalledBiblesState()) {
    on<InstalledBiblesLoad>(_onLoad);
    on<InstalledBiblesUninstall>(_onUninstall);

    _sub = notifier.stream.listen((_) {
      add(InstalledBiblesLoad());
    });
  }

  Future<void> _onLoad(
    InstalledBiblesLoad event,
    Emitter<InstalledBiblesState> emit,
  ) async {
    emit(state.copyWith(status: () => InstalledBiblesStatus.loading));

    final eitherFailureOrData = await repository.getAllInstalledBibles();

    emit(eitherFailureOrData.fold(
      (failure) => state.copyWith(
        status: () => InstalledBiblesStatus.error,
        errorMessage: () => '', // to change with failure
      ),
      (bibles) => state.copyWith(
        status: () => InstalledBiblesStatus.loaded,
        installedBibles: () => bibles,
      ),
    ));
  }

  Future<void> _onUninstall(
    InstalledBiblesUninstall event,
    Emitter<InstalledBiblesState> emit,
  ) async {
    final result = await repository.uninstallTranslation(event.id);

    result.fold(
      (f) => emit(state.copyWith(
        status: () => InstalledBiblesStatus.error,
        errorMessage: () => f.toString(),
      )),
      (_) {
        final updatedList = List<BibleMeta>.from(state.installedBibles);
        updatedList.removeWhere((b) => b.extId == event.id);
        emit(state.copyWith(
          status: () => InstalledBiblesStatus.loaded,
          installedBibles: () => updatedList,
        ));
      },
    );
  }

  @override
  Future<void> close() async {
    await _sub.cancel();
    return super.close();
  }
}
