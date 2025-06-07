// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_smyrna_bible_v2/core/domain/entities/e_bible.dart';
import 'package:the_smyrna_bible_v2/features/bible_installer_manager/domain/repositories/bible_manager_repository.dart';

part 'translations_event.dart';
part 'translations_state.dart';

/// This bloc manages all downloadable translations available
/// from the remote datasource
///
/// - view all translations
/// - start download of a translation
///
const String SERVER_FAILURE_MESSAGE =
    'Oops something went wrong, check your connection';

class AllTranslationsBloc
    extends Bloc<AllTranslationsEvent, AllTranslationsState> {
  final BibleManagerRepository repository;

  AllTranslationsBloc({
    required this.repository,
  }) : super(const AllTranslationsState()) {
    on<AllBiblesSubscriptionRequested>(_onSubscriptionRequested);
  }

  Future<void> _onSubscriptionRequested(
    AllTranslationsEvent event,
    Emitter<AllTranslationsState> emit,
  ) async {
    emit(state.copyWith(status: () => AllTranslationsStatus.loading));

    await Future.delayed(Duration.zero);

    final eitherFailureOrData = await repository.getAllDownloadableBibles();

    emit(eitherFailureOrData.fold(
      (failure) => state.copyWith(
        status: () => AllTranslationsStatus.error,
        errorMessage: () => SERVER_FAILURE_MESSAGE,
      ),
      (infos) => state.copyWith(
        status: () => AllTranslationsStatus.loaded,
        translationInfos: () => infos,
      ),
    ));
  }
}
