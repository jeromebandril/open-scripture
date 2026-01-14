import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_pane/presentation/navigation_bus.dart';

import '../../../../core/domain/entities/bible_ref.dart';
import '../../domain/repositories/b_searchbar_repository.dart';

part 'b_searchbar_event.dart';
part 'b_searchbar_state.dart';

class BSearchbarBloc extends Bloc<BSearchbarEvent, BSearchbarState> {
  BSearchbarBloc({
    required this.repo,
    NavigationBus? navBus,
  })  : _navBus = navBus,
        super(const BSearchbarState()) {
    on<BSearchbarParseIntent>(_onAnalyzeIntent);
    on<_SaveInHistory>(_onSaveInHistory);

    _sub = _navBus?.stream.listen((event) {
      // store intent in history only if from searchbar
      if (event.source != IntentSource.searchbar) return;
      add(_SaveInHistory(event));
    });
  }

  final BSearchbarRepository repo;
  final NavigationBus? _navBus;
  late final StreamSubscription<NavigationFeedback>? _sub;

  Future<void> _onAnalyzeIntent(
    BSearchbarParseIntent event,
    Emitter<BSearchbarState> emit,
  ) async {
    final eitherFailureOrReference = await repo.getParseIntent(event.query);

    return eitherFailureOrReference.fold(
      (_) => print("> BSearchbar: not a valid prompt"),
      (ref) => emit(state.copyWith(
        status: () => BSearchbarStatus.success,
        referenceResult: () => ref,
      )),
    );
  }

  void _onSaveInHistory(
    _SaveInHistory event,
    Emitter<BSearchbarState> emit,
  ) {
    if (event.result.success) {
      emit(state.copyWith(
        history: () => [event.result.ref, ...state.history],
      ));
    }
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}

class _SaveInHistory extends BSearchbarEvent {
  final NavigationFeedback result;
  const _SaveInHistory(this.result);
}
