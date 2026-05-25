import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_scripture/core/infrastructure/event_bus/navigation_bus.dart';
import 'package:open_scripture/features/bible_searchbar/history/domain/entities/history_entry.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit({
    NavigationBus? navBus,
  })  : _navBus = navBus,
        super(const HistoryState()) {
    _sub = _navBus?.stream.listen((event) => _add(event));
  }

  final NavigationBus? _navBus;
  StreamSubscription<NavigationFeedback>? _sub;

  void _add(NavigationFeedback event) {
    if (event.source != IntentSource.searchbar) return;
    if (!event.success) return;

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
