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

class ReaderSetContent extends ReaderEvent {
  final BibleReference ref;

  const ReaderSetContent(this.ref);

  @override
  List<Object> get props => [ref];
}
