part of 'b_searchbar_bloc.dart';

sealed class BSearchbarEvent extends Equatable {
  const BSearchbarEvent();

  @override
  List<Object> get props => [];
}

class BSearchbarAnalyzeIntent extends BSearchbarEvent {
  final String prompt;

  const BSearchbarAnalyzeIntent(this.prompt);

  @override
  List<Object> get props => [prompt];
}
