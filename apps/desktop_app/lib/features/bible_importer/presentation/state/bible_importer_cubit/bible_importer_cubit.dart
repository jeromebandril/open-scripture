import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../../../../../core/infrastructure/event_bus/install_notifier.dart';
import '../../../../../shared/domain/entities/bible_download_progress.dart';
import '../../../../../shared/domain/entities/bible_source.dart';
import '../../../../../shared/domain/repositories/bible_install_repository.dart';
import '../../../../../shared/enums/bible_repository_type.dart';

part 'bible_importer_state.dart';

class BibleImporterCubit extends Cubit<BibleImporterState> {
  final BibleInstallRepository _repo;
  final InstallNotifier _notifier;
  StreamSubscription<InstallProgress>? _sub;

  BibleImporterCubit({
    required BibleInstallRepository repo,
    required InstallNotifier notifier,
  })  : _repo = repo,
        _notifier = notifier,
        super(BibleImporterState());

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }

  Future<void> pickFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip', 'xml'],
      withData: kIsWeb,
      withReadStream: false,
      allowMultiple: false,
      lockParentWindow: true,
    );

    // Aborted
    if (result == null) {
      emit(state.copyWith(status: BibleImporterStatus.initial));
      return;
    }

    final picked = result.files.single;
    final name = picked.name;

    final BibleSourceType src;

    if (picked.bytes != null) {
      src = MemoryFileSource(bytes: picked.bytes!, displayName: name);
    } else if (picked.path != null) {
      src = LocalFileSource(filePath: picked.path!, displayName: name);
    } else {
      emit(state.copyWith(status: BibleImporterStatus.failed));
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

    final stream = _repo.install(src, state.targetType);

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
      onError: (error) {
        emit(state.copyWith(
          status: BibleImporterStatus.failed,
          errorMessage: () => 'Unexpected error: $error',
        ));
      },
      onDone: () {
        // If repo always emits done, you may not need this.
        if (state.progress?.stage != InstallStage.done) {
          emit(state.copyWith(status: BibleImporterStatus.succeed));
        }
        _notifier.refreshInstalledList();
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

  void setTargetType(BibleRepositoryType? targetType) {
    emit(state.copyWith(targetType: targetType));
  }
}
