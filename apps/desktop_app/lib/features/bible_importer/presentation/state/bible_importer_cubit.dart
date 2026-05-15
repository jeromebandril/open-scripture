import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_scripture/features/bible_importer/domain/repository/bible_importer_repo.dart';

import '../../../../core/infrastructure/event_bus/install_notifier.dart';
import '../../../bible_installer_manager/domain/entities/bible_download_progress.dart';

part 'bible_importer_state.dart';

class BibleImporterCubit extends Cubit<BibleImporterState> {
  BibleImporterCubit({required this.repo, required this.notifier})
      : super(BibleImporterState());

  final BibleImporterRepo repo;

  final InstallNotifier notifier;
  StreamSubscription<InstallProgress>? _sub;

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip', 'xml'],
      withData: false,
      withReadStream: false,
      allowMultiple: false,
      lockParentWindow: true,
    );

    final path = result?.files.single.path;
    final name = result?.files.single.name; // safer than result.names.single

    if (path == null) {
      emit(state.copyWith(status: BibleImporterStatus.initial));
      return;
    }

    // Cancel any ongoing install
    await _sub?.cancel();

    emit(state.copyWith(
      status: BibleImporterStatus.running,
      fileName: name,
      progress: const InstallProgress(
        stage: InstallStage.installing,
        message: 'Starting...',
      ),
    ));

    final stream = repo.importAndInstallFromPath(
      path,
      displayName: name ?? _basename(path),
    );

    _sub = stream.listen(
      (p) {
        if (p.stage == InstallStage.failed) {
          emit(state.copyWith(
            status: BibleImporterStatus.failed,
            errorMessage: () => p.message,
          ));
          return;
        }
        emit(state.copyWith(
          status: _mapStageToStatus(p.stage),
          progress: p,
          errorMessage: () => null,
        ));
      },
      onDone: () {
        // If repo always emits done, you may not need this.
        if (state.progress?.stage != InstallStage.done) {
          emit(state.copyWith(status: BibleImporterStatus.succeed));
        }
        notifier.refreshInstalledList();
      },
      cancelOnError: false,
    );
  }

  BibleImporterStatus _mapStageToStatus(InstallStage stage) {
    switch (stage) {
      case InstallStage.failed:
        return BibleImporterStatus.failed;
      case InstallStage.done:
        return BibleImporterStatus.succeed;
      default:
        return BibleImporterStatus.running;
    }
  }

  String _basename(String path) => path.split(RegExp(r'[\\/]+')).last;
}
