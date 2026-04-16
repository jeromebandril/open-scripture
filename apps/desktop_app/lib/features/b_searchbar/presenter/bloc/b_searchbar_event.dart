part of 'b_searchbar_bloc.dart';

sealed class BSearchbarEvent extends Equatable {
  const BSearchbarEvent();

  @override
  List<Object> get props => [];
}

class BSearchbarParseIntent extends BSearchbarEvent {
  final String query;

  const BSearchbarParseIntent(this.query);

  @override
  List<Object> get props => [query];
}

class BSearchbarFind extends BSearchbarEvent {
  final List<int> bibleIds;
  final String query;

  const BSearchbarFind({
    required this.bibleIds,
    required this.query,
  });

  @override
  List<Object> get props => [bibleIds, query];
}

class DeleteHistoryItem extends BSearchbarEvent {
  final int index;
  const DeleteHistoryItem(this.index);

  @override
  List<Object> get props => [index];
}
