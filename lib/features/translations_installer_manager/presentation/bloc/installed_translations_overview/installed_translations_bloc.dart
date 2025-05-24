import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/domain/usecases/uninstall_translation.dart';

import '../../../domain/entities/translation_info.dart';
import '../../../domain/usecases/get_local_translations_info_list.dart';

part 'installed_translations_event.dart';
part 'installed_translations_state.dart';

/// This bloc manages the installed translations:
///
/// - View all locally installed translations
/// - Uninstall translations
///
const String noLocalDataFailureMessage = 'No Local Data';

class InstalledTranslationsBloc
    extends Bloc<InstalledTranslationsEvent, InstalledTranslationsState> {
  final GetLocalTranslationsInfoList getLocalTranslationsInfoList;
  final UninstallTranslation uninstallTranslation;

  InstalledTranslationsBloc({
    required this.getLocalTranslationsInfoList,
    required this.uninstallTranslation,
  }) : super(const InstalledTranslationsState()) {
    on<InstalledTranslationsSubscriptionRequested>(_onSubscriptionRequested);
    on<InstalledTranslationUninstall>(_onUninstall);
  }

  Future<void> _onSubscriptionRequested(
    InstalledTranslationsSubscriptionRequested event,
    Emitter<InstalledTranslationsState> emit,
  ) async {
    emit(state.copyWith(status: () => InstalledTranslationsStatus.loading));

    await Future.delayed(Duration.zero);

    final eitherFailureOrData = await getLocalTranslationsInfoList(null);

    emit(eitherFailureOrData.fold(
      (failure) => state.copyWith(
        status: () => InstalledTranslationsStatus.error,
        errorMessage: () => noLocalDataFailureMessage,
      ),
      (infos) => state.copyWith(
        status: () => InstalledTranslationsStatus.loaded,
        installedTranslationsInfos: () => infos,
      ),
    ));
  }

  Future<void> _onUninstall(
    InstalledTranslationUninstall event,
    Emitter<InstalledTranslationsState> emit,
  ) async {
    await uninstallTranslation(event.id);
  }
}
