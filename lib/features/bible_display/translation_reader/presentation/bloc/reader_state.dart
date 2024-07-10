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
    this.reference = const BibleReference(book: '', chapter: 0, verse: 0),
    this.references = const [],
  });

  final ReaderStatus status;
  final BibleReference reference;
  final List<BibleReference> references;

  ReaderState copyWith({
    ReaderStatus Function()? status,
    BibleReference Function()? reference,
    List<BibleReference> Function()? references,
  }) {
    return ReaderState(
      status: status != null ? status() : this.status,
      reference: reference != null ? reference() : this.reference,
      references: references != null ? references() : this.references,
    );
  }

  @override
  List<Object> get props => [status, reference, references];
}
