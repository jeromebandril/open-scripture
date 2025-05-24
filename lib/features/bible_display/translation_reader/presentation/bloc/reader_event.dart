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

class ReaderDisplay extends ReaderEvent {
  final BibleReference bibleRef;

  const ReaderDisplay(this.bibleRef);

  @override
  List<Object> get props => [bibleRef];
}
