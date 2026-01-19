import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_smyrna_bible_v2/features/b_searchbar/domain/repositories/b_search_intent_type.dart';
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
    on<_ExecuteIntent>(_onExecuteIntent);

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
    // map intent type

    if (int.tryParse(event.query) != null) {
      add(_ExecuteIntent(BSearchIntentType.gotoVerseNumber, event.query));
      return;
    }
    if (event.query.startsWith('\$')) {
      // TODO: search from text
      return;
    }

    add(_ExecuteIntent(BSearchIntentType.gotoReference, event.query));
    return;
  }

  Future<void> _onExecuteIntent(
    _ExecuteIntent event,
    Emitter<BSearchbarState> emit,
  ) async {
    if (event.intentType == BSearchIntentType.gotoReference) {
      final eitherFailureOrReference = await repo.getParseIntent(event.query);

      return eitherFailureOrReference.fold(
        (_) => print("> BSearchbar: not a valid prompt"),
        (ref) => emit(state.copyWith(
          intentType: () => BSearchIntentType.gotoReference,
          status: () => BSearchbarStatus.success,
          referenceResult: () => ref,
        )),
      );
    }

    if (event.intentType == BSearchIntentType.gotoVerseNumber) {
      if (state.referenceResult == null) return;
      final vn = int.tryParse(event.query);
      if (vn == null || vn < 0) return;
      return emit(state.copyWith(
        intentType: () => BSearchIntentType.gotoVerseNumber,
        status: () => BSearchbarStatus.success,
        referenceResult: () => state.referenceResult!.copyWith(
          verseStart: vn,
          verseEnd: null,
        ),
      ));
    }
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

class _ExecuteIntent extends BSearchbarEvent {
  final BSearchIntentType intentType;
  final String query;
  const _ExecuteIntent(this.intentType, this.query);
}
