// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/translation_info.dart';
import '../../../domain/usecases/get_translations_info_list.dart';

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
  final GetTranslationsInfoList getTranslationsInfoList;

  AllTranslationsBloc({
    required this.getTranslationsInfoList,
  }) : super(const AllTranslationsState()) {
    on<AllTranslationsSubscriptionRequested>(_onSubscriptionRequested);
  }

  Future<void> _onSubscriptionRequested(
    AllTranslationsEvent event,
    Emitter<AllTranslationsState> emit,
  ) async {
    emit(state.copyWith(status: () => AllTranslationsStatus.loading));

    await Future.delayed(Duration.zero);

    final eitherFailureOrData = await getTranslationsInfoList(null);
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

  Stream<AllTranslationsEvent> get events => events;
}
