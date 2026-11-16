import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

import '../../domain/entities/pericope_set.dart';
import '../../domain/repositories/pericopes_mgr_repo.dart';

part 'pericopes_mgr_state.dart';

class PericopesMgrCubit extends Cubit<PericopesMgrState> {
  final PericopesMgrRepo _repo;

  PericopesMgrCubit({required PericopesMgrRepo repo})
      : _repo = repo,
        super(PericopesMgrState());

  Future<void> pickFileToImport() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: false,
      withReadStream: false,
      allowMultiple: false,
      lockParentWindow: true,
    );

    if (result == null) {
      emit(state.copyWith(importStatus: PericopesMgrStatus.initial));
      return;
    }

    final picked = result.files.single;

    emit(state.copyWith(importStatus: PericopesMgrStatus.loading));

    if (picked.path == null) {
      emit(state.copyWith(importStatus: PericopesMgrStatus.error));
      return;
    }
    final task = await _repo.import(picked.path!).run();

    task.fold(
      (f) => emit(state.copyWith(
          importStatus: PericopesMgrStatus.error,
          errorMessage: () => f.cause.toString())),
      (_) => emit(state.copyWith(importStatus: PericopesMgrStatus.success)),
    );
  }

  Future<void> loadInstalledPericopes() async {
    emit(state.copyWith(listStatus: PericopesMgrStatus.loading));

    final result = await _repo.getInstalledPericopes().run();

    result.fold(
      (f) => emit(state.copyWith(listStatus: PericopesMgrStatus.error)),
      (p) => state.copyWith(
        listStatus: PericopesMgrStatus.success,
        installedPericopes: p,
      ),
    );
  }
}
