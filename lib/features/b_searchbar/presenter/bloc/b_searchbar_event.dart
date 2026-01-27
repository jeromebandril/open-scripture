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
  final int bibleId;
  final String query;

  const BSearchbarFind({
    required this.bibleId,
    required this.query,
  });

  @override
  List<Object> get props => [bibleId, query];
}

class DeleteHistoryItem extends BSearchbarEvent {
  final int index;
  const DeleteHistoryItem(this.index);

  @override
  List<Object> get props => [index];
}
