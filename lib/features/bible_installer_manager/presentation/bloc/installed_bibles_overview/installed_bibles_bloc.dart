import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_smyrna_bible_v2/core/domain/entities/e_bible.dart';
import 'package:the_smyrna_bible_v2/features/bible_installer_manager/domain/repositories/bible_manager_repository.dart';

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

  InstalledBiblesBloc({
    required this.repository,
  }) : super(const InstalledBiblesState()) {
    on<InstalledBiblesSubscriptionRequested>(_onSubscriptionRequested);
    on<InstalledBiblesUninstall>(_onUninstall);
  }

  Future<void> _onSubscriptionRequested(
    InstalledBiblesSubscriptionRequested event,
    Emitter<InstalledBiblesState> emit,
  ) async {
    emit(state.copyWith(status: () => InstalledTranslationsStatus.loading));

    await Future.delayed(Duration.zero);

    final eitherFailureOrData = await repository.getAllInstalledBibles();

    emit(eitherFailureOrData.fold(
      (failure) => state.copyWith(
        status: () => InstalledTranslationsStatus.error,
        errorMessage: () => '', // to change with failure
      ),
      (bibles) => state.copyWith(
        status: () => InstalledTranslationsStatus.loaded,
        installedBibles: () => bibles,
      ),
    ));
  }

  Future<void> _onUninstall(
    InstalledBiblesUninstall event,
    Emitter<InstalledBiblesState> emit,
  ) async {
    await repository.uninstallTranslation(event.id);
  }
}
