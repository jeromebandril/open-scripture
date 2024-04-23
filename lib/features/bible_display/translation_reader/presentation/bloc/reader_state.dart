part of 'reader_bloc.dart';

enum ReaderStatus {
  initial,
  reading,
  success,
  error,
}

class ReaderState extends Equatable {
  const ReaderState({
    this.status = ReaderStatus.initial,
    this.viewer = const TranslationViewer(),
    this.reference = const BibleReference(book: '', chapter: 0, verse: 0),
    this.references = const [],
  });

  final ReaderStatus status;
  final TranslationViewer viewer;
  final BibleReference reference;
  final List<BibleReference> references;

  ReaderState copyWith({
    ReaderStatus Function()? status,
    TranslationViewer Function()? viewer,
    BibleReference Function()? reference,
    List<BibleReference> Function()? references,
  }) {
    return ReaderState(
      status: status != null ? status() : this.status,
      viewer: viewer != null ? viewer() : this.viewer,
      reference: reference != null ? reference() : this.reference,
      references: references != null ? references() : this.references,
    );
  }

  @override
  List<Object> get props => [status, viewer, reference, references];
}
