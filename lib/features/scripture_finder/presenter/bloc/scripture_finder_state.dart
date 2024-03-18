part of 'scripture_finder_bloc.dart';

sealed class ScriptureFinderState extends Equatable {
  const ScriptureFinderState();
  
  @override
  List<Object> get props => [];
}

final class ScriptureFinderInitial extends ScriptureFinderState {}
