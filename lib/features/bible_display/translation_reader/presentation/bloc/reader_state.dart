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
    this.reference,
    this.verses = const [],
  });

  final ReaderStatus status;
  final BibleReference? reference;
  final List<EVerse> verses;

  ReaderState copyWith({
    ReaderStatus Function()? status,
    BibleReference Function()? reference,
    List<EVerse> Function()? verses,
  }) {
    return ReaderState(
      status: status != null ? status() : this.status,
      reference: reference != null ? reference() : this.reference,
      verses: verses != null ? verses() : this.verses,
    );
  }

  @override
  List<Object?> get props => [
        status,
        reference,
        verses,
      ];
}
