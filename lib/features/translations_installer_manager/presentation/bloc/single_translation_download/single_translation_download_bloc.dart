import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:rxdart/rxdart.dart';
import 'package:the_smyrna_bible_v2/features/translations_installer_manager/domain/usecases/download_translation.dart';

import '../../../../../core/error/failure.dart';

part 'single_translation_download_event.dart';
part 'single_translation_download_state.dart';

/// This bloc manages the download status of the translation
///
/// - Pause downlaod
/// - Resume download
/// - Cancel download
/// - View download progress
class SingleTranslationDownloadBloc extends Bloc<SingleTranslationDownloadEvent,
    SingleTranslationDownloadState> {
  final DownloadTranslation downloadTranslation;
  final BehaviorSubject download = BehaviorSubject();

  SingleTranslationDownloadBloc({
    required this.downloadTranslation,
  }) : super(const SingleTranslationDownloadState()) {
    on<SingleTranslationDownloadPause>(_onPause);
    on<SingleTranslationDownloadResume>(_onResume);
    on<SingleTranslationDownloadCancel>(_onCancel);
    on<SingleTranslationDownloadPressed>(_onDownload);
  }

  Future<void> _onDownload(
    SingleTranslationDownloadPressed event,
    Emitter<SingleTranslationDownloadState> emit,
  ) async {
    await emit.forEach<Either<Failure, List<int>>>(
      downloadTranslation(event.id),
      onData: (eitherFaulureOrData) {
        return eitherFaulureOrData.fold(
          (l) => state.copyWith(
            status: () => SingleTranslationDownloadStatus.error,
          ),
          (download) => state.copyWith(
            status: () => SingleTranslationDownloadStatus.downloading,
            totalBytes: () => download[1],
            receivedBytes: () => download[0],
          ),
        );
      },
    );
  }

  Future<void> _onPause(SingleTranslationDownloadPause event,
      Emitter<SingleTranslationDownloadState> emit) async {
    emit(state.copyWith(
      status: () => SingleTranslationDownloadStatus.paused,
    ));
  }

  Future<void> _onResume(SingleTranslationDownloadResume event,
      Emitter<SingleTranslationDownloadState> emit) async {
    emit(state.copyWith(
      status: () => SingleTranslationDownloadStatus.downloading,
    ));
  }

  Future<void> _onCancel(SingleTranslationDownloadCancel event,
      Emitter<SingleTranslationDownloadState> emit) async {
    emit(state.copyWith(
      status: () => SingleTranslationDownloadStatus.canceled,
    ));
  }
}
