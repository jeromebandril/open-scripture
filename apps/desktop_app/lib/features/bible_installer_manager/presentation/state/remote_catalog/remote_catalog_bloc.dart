// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_scripture/shared/entities/bible_meta.dart';
import 'package:open_scripture/features/bible_installer_manager/domain/repositories/bible_manager_repository.dart';

part 'remote_catalog_event.dart';
part 'remote_catalog_state.dart';

/// This bloc manages all downloadable translations available
/// from the remote datasource
///
/// - view all translations
/// - start download of a translation
///
const String SERVER_FAILURE_MESSAGE =
    'Oops something went wrong, check your connection';

class RemoteCatalogBloc extends Bloc<RemoteCatalogEvent, RemoteCatalogState> {
  final BibleManagerRepository repository;

  RemoteCatalogBloc({
    required this.repository,
  }) : super(const RemoteCatalogState()) {
    on<RemoteCatalogSubscriptionRequested>(_onSubscriptionRequested);
  }

  Future<void> _onSubscriptionRequested(
    RemoteCatalogEvent event,
    Emitter<RemoteCatalogState> emit,
  ) async {
    emit(state.copyWith(status: () => RemoteCatalogStatus.loading));

    await Future.delayed(Duration.zero);

    final eitherFailureOrData = await repository.getAllDownloadableBibles();

    emit(eitherFailureOrData.fold(
      (failure) => state.copyWith(
        status: () => RemoteCatalogStatus.error,
        errorMessage: () => SERVER_FAILURE_MESSAGE,
      ),
      (bibles) => state.copyWith(
        status: () => RemoteCatalogStatus.loaded,
        bibles: () => bibles,
      ),
    ));
  }
}
