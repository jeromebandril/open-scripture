part of 'reader_bloc.dart';

sealed class ReaderEvent extends Equatable {
  const ReaderEvent();

  @override
  List<Object> get props => [];
}

class ReaderLoadTranslation extends ReaderEvent {
  final String id;

  const ReaderLoadTranslation(this.id);

  @override
  List<Object> get props => [id];
}

class ReaderAnalyzePrompt extends ReaderEvent {
  final String text;

  const ReaderAnalyzePrompt(this.text);

  @override
  List<Object> get props => [text];
}
