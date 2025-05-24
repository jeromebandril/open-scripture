import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/bible_reference.dart';
import '../../domain/repositories/b_searchbar_repository.dart';

part 'b_searchbar_event.dart';
part 'b_searchbar_state.dart';

class BSearchbarBloc extends Bloc<BSearchbarEvent, BSearchbarState> {
  final BSearchbarRepository repo;

  BSearchbarBloc({
    required this.repo,
  }) : super(const BSearchbarState()) {
    on<BSearchbarAnalyzeIntent>(_onAnalyzeIntent);
  }

  Future<void> _onAnalyzeIntent(
    BSearchbarAnalyzeIntent event,
    Emitter<BSearchbarState> emit,
  ) async {
    final eitherFailureOrReference = await repo.getBibleReference(event.prompt);

    eitherFailureOrReference.fold(
      (_) => print("> BSearchbar: not a valid prompt"),
      (ref) => emit(state.copyWith(
        status: () => BSearchbarStatus.success,
        referenceResult: () => ref,
      )),
    );
  }
}
