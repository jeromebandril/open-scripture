import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/domain/entities/bible_meta.dart';
import '../../../domain/entities/bible_download_progress.dart';
import '../../../domain/repositories/bible_manager_repository.dart';

part 'bible_download_progress_event.dart';
part 'bible_download_progress_state.dart';

/// This bloc manages the download progress state of one translation
///
/// - Pause downlaod
/// - Resume download
/// - Cancel download
/// - View download progress
///
const String INSTALLATION_FAILURE_MESSAGE = 'Failed To Install';

class BibleDownloadProgressBloc
    extends Bloc<TranslationDownloadProgressEvent, BibleDownloadProgressState> {
  final BibleManagerRepository repository;
  StreamSubscription<InstallProgress>? _progressSubscription;

  BibleDownloadProgressBloc({
    required this.repository,
  }) : super(BibleDownloadProgressState()) {
    // on<BibleDownloadProgressPause>(_onPause);
    // on<BibleDownloadProgressResume>(_onResume);
    // on<BibleDownloadProgressCancel>(_onCancel);
    on<BibleDownloadProgressPressed>(_onDownload);
  }

  Future<void> _onDownload(
    BibleDownloadProgressPressed event,
    Emitter<BibleDownloadProgressState> emit,
  ) async {
    /* Make download */
    final failureOrStream = await repository.downloadBible(
      event.bible.abbreviation,
    );

    _progressSubscription?.cancel();

    // await failureOrStream.fold((failure) => null, (stream) async {
    //   await emit.forEach(stream, onData: (progress) {
    //     return state.copyWith(
    //       progress: () => progress,
    //       errorMessage: null,
    //     );
    //   }, onError: (_, __) {
    //     return state.copyWith(
    //       progress: null,
    //       errorMessage: () => INSTALLATION_FAILURE_MESSAGE,
    //     );
    //   });

    //   // _progressSubscription = stream.listen((progress) {
    //   //   //print('${progress.received}/${progress.total}');
    //   //   if (!emit.isDone) {
    //   //     emit();
    //   //   } else {
    //   //     print('isdone!');
    //   //   }
    //   // }, onError: (_) {
    //   //   print("errore!!!");
    //   // });
    // });

    /* Make installation */
    // emit(state.copyWith(
    //   progress: () => state.progress!.copyWith(
    //     stage: () => DownloadStatus.installing,
    //   ),
    // ));

    final failureOrInstalled = await repository.installBible(
      event.bible.abbreviation,
    );

    // await failureOrInstalled.fold((failure) {}, (_) async {
    //   return emit(state.copyWith(
    //     progress: () => state.progress!.copyWith(
    //       stage: () => DownloadStatus.installed,
    //     ),
    //   ));
    // });

    /*
      ).then((_) async {
        // after try installation
        final newDTranslations = Map<String, BibleDownloadProgess>.from(
          state.downloadingTranslations,
        );
        newDTranslations[event.id] = newDTranslations[event.id]!.copyWith(
          downloadStatus: () => DownloadStatus.installing,
        );
        emit(state.copyWith(
          downloadingTranslations: () => newDTranslations,
        ));
        await repository.installTranslation(event.id).then((_) {
          newDTranslations[event.id] = newDTranslations[event.id]!.copyWith(
            downloadStatus: () => DownloadStatus.installed,
          );
          emit(state.copyWith(
            downloadingTranslations: () => newDTranslations,
          ));
        });
      });
      */
  }

  /*
  Future<void> _onPause(
    BibleDownloadProgressPause event,
    Emitter<BibleDownloadProgressState> emit,
  ) async {
    /*
    Map<String, BibleDownloadProgess> newDTranslations = Map.from(
      state.downloadingTranslations,
    );
    newDTranslations[event.id] = BibleDownloadProgess(
      id: event.id,
      name: event.id,
      language: event.id,
      downloadStatus: DownloadStatus.paused,
    );
    emit(state.copyWith(downloadingTranslations: () => newDTranslations));
    */
  }

  Future<void> _onResume(BibleDownloadProgressResume event,
      Emitter<BibleDownloadProgressState> emit) async {
    /*
    Map<String, BibleDownloadProgess> newDTranslations = Map.from(
      state.downloadingTranslations,
    );
    newDTranslations[event.id] = BibleDownloadProgess(
      id: event.id,
      name: event.id,
      language: event.id,
      downloadStatus: DownloadStatus.inProgress,
    );

    emit(state.copyWith(downloadingTranslations: () => newDTranslations));
    */
  }

  Future<void> _onCancel(BibleDownloadProgressCancel event,
      Emitter<BibleDownloadProgressState> emit) async {
    await _progressSubscription?.cancel();
    emit(BibleDownloadProgressState(
      progress: state.progress
          ?.copyWith(downloadStatus: () => DownloadStatus.canceled),
    ));
  }
  */
}
