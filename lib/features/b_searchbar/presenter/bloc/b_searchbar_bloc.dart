import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/bible_ref.dart';
import '../../domain/repositories/b_searchbar_repository.dart';

part 'b_searchbar_event.dart';
part 'b_searchbar_state.dart';

class BSearchbarBloc extends Bloc<BSearchbarEvent, BSearchbarState> {
  final BSearchbarRepository repo;

  BSearchbarBloc({
    required this.repo,
  }) : super(const BSearchbarState()) {
    on<BSearchbarParseIntent>(_onAnalyzeIntent);
  }

  Future<void> _onAnalyzeIntent(
    BSearchbarParseIntent event,
    Emitter<BSearchbarState> emit,
  ) async {
    final eitherFailureOrReference = await repo.getParseIntent(event.query);

    eitherFailureOrReference.fold(
      (_) => print("> BSearchbar: not a valid prompt"),
      (ref) => emit(state.copyWith(
        status: () => BSearchbarStatus.success,
        referenceResult: () => ref,
      )),
    );
  }
}
