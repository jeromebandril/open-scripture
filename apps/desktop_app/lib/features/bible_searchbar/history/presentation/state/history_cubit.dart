import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/infrastructure/event_bus/search_result_bus.dart';
import '../../domain/entities/history_entry.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit({
    SearchResultBus? navBus,
  })  : _navBus = navBus,
        super(const HistoryState()) {
    _sub = _navBus?.stream.listen((event) => _add(event));
  }

  final SearchResultBus? _navBus;
  StreamSubscription<SearchResultEvent>? _sub;

  void _add(SearchResultEvent event) {
    if (event.source != IntentSource.searchbar) return;
    if (event is! SearchResultSuccess) return;
    if (state.history.isNotEmpty && state.history.first.ref == event.ref) {
      return;
    }

    final entry = HistoryEntry(ref: event.ref, time: DateTime.now());
    final updatedHistory = [entry, ...state.history];

    emit(HistoryState(history: updatedHistory));
  }

  void remove(int index) {
    final updatedHistory = List.of(state.history)..removeAt(index);
    emit(HistoryState(history: updatedHistory));
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
