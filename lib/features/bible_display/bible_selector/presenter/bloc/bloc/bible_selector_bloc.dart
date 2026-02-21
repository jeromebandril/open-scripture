import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_scripture/features/bible_display/bible_selector/domain/repositories/bible_selector_repository.dart';

part 'bible_selector_event.dart';
part 'bible_selector_state.dart';

class BibleSelectorBloc extends Bloc<BibleSelectorEvent, BibleSelectorState> {
  final BibleSelectorRepository repo;

  BibleSelectorBloc({
    required this.repo,
  }) : super(const BibleSelectorState()) {
    on<BibleSelectorInit>(_loadInstalledBibles);
    on<BibleSelectorSelect>(_onBibleSelectorSelect);
  }

  Future<void> _loadInstalledBibles(
    BibleSelectorInit event,
    Emitter<BibleSelectorState> emit,
  ) async {
    final failOrBibles = await repo.getInstalledBibles();
    failOrBibles.fold(
      (f) => emit(
        state.copyWith(
            status: () => BibleSelectorStatus.error,
            errorMessage: () => f.toString()),
      ),
      (bibles) {
        if (bibles.isEmpty) {
          emit(state.copyWith(
            status: () => BibleSelectorStatus.error,
            errorMessage: () =>
                'Bruh, you still don\'t have any bible installed',
          ));
        } else {
          emit(state.copyWith(
            selectedBibleId:
                state.selectedBibleId == null ? () => bibles.first.id : null,
            status: () => BibleSelectorStatus.ready,
          ));
        }
      },
    );
  }

  Future<void> _onBibleSelectorSelect(
    BibleSelectorSelect event,
    Emitter<BibleSelectorState> emit,
  ) async {
    emit(state.copyWith(selectedBibleId: () => event.selectedBibleId));
  }
}
