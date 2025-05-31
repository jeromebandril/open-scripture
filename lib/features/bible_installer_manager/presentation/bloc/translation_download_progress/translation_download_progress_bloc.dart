import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_smyrna_bible_v2/features/bible_installer_manager/domain/entities/translation_info.dart';
import 'package:the_smyrna_bible_v2/features/bible_installer_manager/domain/usecases/download_translation.dart';
import 'package:the_smyrna_bible_v2/features/bible_installer_manager/domain/usecases/install_translation.dart';

part 'translation_download_progress_event.dart';
part 'translation_download_progress_state.dart';

/// This bloc manages the download progress state of one translation
///
/// - Pause downlaod
/// - Resume download
/// - Cancel download
/// - View download progress
///
const String INSTALLATION_FAILURE_MESSAGE = 'Failed To Install';

class TranslationDownloadProgressBloc extends Bloc<
    TranslationDownloadProgressEvent, TranslationDownloadProgressState> {
  final DownloadTranslation downloadTranslation;
  final InstallUsfxTranslation installTranslation;

  TranslationDownloadProgressBloc({
    required this.downloadTranslation,
    required this.installTranslation,
  }) : super(const TranslationDownloadProgressState()) {
    on<TranslationDownloadProgressPause>(_onPause);
    on<TranslationDownloadProgressResume>(_onResume);
    on<TranslationDownloadProgressCancel>(_onCancel);
    on<TranslationDownloadProgressPressed>(_onDownload);
  }

  Future<void> _onDownload(
    TranslationDownloadProgressPressed event,
    Emitter<TranslationDownloadProgressState> emit,
  ) async {
    final failureOrStream = await downloadTranslation(event.id);

    await failureOrStream.fold((failure) => null, (stream) async {
      // download
      await emit.forEach<List<int>>(
        stream,
        onData: (data) {
          final newDTranslations = Map<String, TranslationInfo>.from(
            state.downloadingTranslations,
          );
          newDTranslations[event.id] = TranslationInfo(
            id: event.id,
            name: event.id,
            language: event.id,
            total: data.last,
            received: data.first,
            downloadStatus: DownloadStatus.downloading,
          );
          return state.copyWith(
            downloadingTranslations: () => newDTranslations,
          );
        },
      ).then((_) async {
        // after try installation
        final newDTranslations = Map<String, TranslationInfo>.from(
          state.downloadingTranslations,
        );
        newDTranslations[event.id] = newDTranslations[event.id]!.copyWith(
          downloadStatus: () => DownloadStatus.installing,
        );
        emit(state.copyWith(
          downloadingTranslations: () => newDTranslations,
        ));
        await installTranslation(event.id).then((_) {
          newDTranslations[event.id] = newDTranslations[event.id]!.copyWith(
            downloadStatus: () => DownloadStatus.installed,
          );
          emit(state.copyWith(
            downloadingTranslations: () => newDTranslations,
          ));
        });
      });
    });
  }

  Future<void> _onPause(
    TranslationDownloadProgressPause event,
    Emitter<TranslationDownloadProgressState> emit,
  ) async {
    Map<String, TranslationInfo> newDTranslations = Map.from(
      state.downloadingTranslations,
    );
    newDTranslations[event.id] = TranslationInfo(
      id: event.id,
      name: event.id,
      language: event.id,
      downloadStatus: DownloadStatus.paused,
    );
    emit(state.copyWith(downloadingTranslations: () => newDTranslations));
  }

  Future<void> _onResume(TranslationDownloadProgressResume event,
      Emitter<TranslationDownloadProgressState> emit) async {
    Map<String, TranslationInfo> newDTranslations = Map.from(
      state.downloadingTranslations,
    );
    newDTranslations[event.id] = TranslationInfo(
      id: event.id,
      name: event.id,
      language: event.id,
      downloadStatus: DownloadStatus.downloading,
    );

    emit(state.copyWith(downloadingTranslations: () => newDTranslations));
  }

  Future<void> _onCancel(TranslationDownloadProgressCancel event,
      Emitter<TranslationDownloadProgressState> emit) async {
    // emit(state.copyWith(
    //   status: () => TranslationDownloadProgressStatus.canceled,
    // ));
  }
}
