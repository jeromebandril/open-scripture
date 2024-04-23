part of 'reader_bloc.dart';

sealed class ReaderEvent extends Equatable {
  const ReaderEvent();

  @override
  List<Object> get props => [];
}

class ReaderReadTranslation extends ReaderEvent {
  final String id;

  const ReaderReadTranslation(this.id);

  @override
  List<Object> get props => [id];
}

class ReaderViewChapter extends ReaderEvent {
  final String text;

  const ReaderViewChapter(this.text);

  @override
  List<Object> get props => [text];
}
