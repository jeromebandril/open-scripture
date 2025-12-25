import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/entities/bible_download_progress.dart';
import '../../../../domain/repositories/bible_manager_repository.dart';
import '../../../../../../core/presentation/state_manager/install_notifier.dart';

part 'download_manager_event.dart';
part 'download_manager_state.dart';

class DownloadManagerBloc
    extends Bloc<DownloadManagerEvent, DownloadManagerState> {
  final BibleManagerRepository repo;
  final InstallNotifier notifier;
  final _subs = <String, StreamSubscription<InstallProgress>>{};

  DownloadManagerBloc({
    required this.repo,
    required this.notifier,
  }) : super(const DownloadManagerState()) {
    on<StartInstall>(_onStart);
    on<_ProgressUpdate>(_onProgress);
  }

  void _onStart(StartInstall event, Emitter<DownloadManagerState> emit) {
    final id = event.bibleId;

    // Avoid starting twice
    if (_subs.containsKey(id)) return;

    // Optional: mark as queued/downloading immediately
    final next = Map<String, InstallProgress>.from(state.progressByBibleId);
    next[id] = const InstallProgress(
      stage: InstallStage.downloading,
      received: 0,
      total: 0,
    );
    emit(state.copyWith(progressByBibleId: next));

    final sub = repo.downloadAndInstallBible(id).listen(
          (p) => add(_ProgressUpdate(id, p)),
          onError: (e, _) => add(_ProgressUpdate(
            id,
            InstallProgress(stage: InstallStage.failed, message: 'Failed'),
          )),
          onDone: () {
            _subs.remove(id)?.cancel();
          },
        );

    _subs[id] = sub;
  }

  void _onProgress(_ProgressUpdate event, Emitter<DownloadManagerState> emit) {
    final next = Map<String, InstallProgress>.from(state.progressByBibleId);
    next[event.bibleId] = event.progress;
    emit(state.copyWith(progressByBibleId: next));

    if (event.progress.stage == InstallStage.done) {
      notifier.installed(event.bibleId);
      _subs.remove(event.bibleId)?.cancel();
    }
    if (event.progress.stage == InstallStage.failed) {
      _subs.remove(event.bibleId)?.cancel();
    }
  }

  Future<void> _onCancel(
      CancelInstall event, Emitter<DownloadManagerState> emit) async {
    await _subs.remove(event.bibleId)?.cancel();

    final next = Map<String, InstallProgress>.from(state.progressByBibleId);
    next[event.bibleId] = const InstallProgress(stage: InstallStage.canceled);
    emit(state.copyWith(progressByBibleId: next));
  }
}
