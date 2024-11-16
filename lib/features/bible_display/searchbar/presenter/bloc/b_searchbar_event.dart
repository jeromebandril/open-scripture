part of 'b_searchbar_bloc.dart';

sealed class BSearchbarEvent extends Equatable {
  const BSearchbarEvent();

  @override
  List<Object> get props => [];
}

class BSearchbarAnalyze extends BSearchbarEvent {
  final String prompt;

  const BSearchbarAnalyze(this.prompt);

  @override
  List<Object> get props => [prompt];
}
