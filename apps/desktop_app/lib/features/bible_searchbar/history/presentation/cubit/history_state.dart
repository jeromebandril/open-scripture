part of 'history_cubit.dart';

class HistoryState extends Equatable {
  const HistoryState({this.history = const []});

  final List<HistoryEntry> history;

  @override
  List<Object?> get props => [history];
}
