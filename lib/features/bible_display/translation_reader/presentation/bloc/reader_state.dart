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
    this.reference = const BibleReference(),
    this.references = const [],
    this.TEMP_TRANSLATION,
  });

  final ReaderStatus status;
  final BibleReference reference;
  final List<BibleReference> references;
  final Translation? TEMP_TRANSLATION;

  ReaderState copyWith({
    ReaderStatus Function()? status,
    BibleReference Function()? reference,
    List<BibleReference> Function()? references,
    Translation Function()? TEMP_TRANSLATION,
  }) {
    return ReaderState(
      status: status != null ? status() : this.status,
      reference: reference != null ? reference() : this.reference,
      references: references != null ? references() : this.references,
      TEMP_TRANSLATION:
          TEMP_TRANSLATION != null ? TEMP_TRANSLATION() : this.TEMP_TRANSLATION,
    );
  }

  @override
  List<Object> get props => [status, reference, references];
}
