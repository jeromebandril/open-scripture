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
    this.reference = const BibleRef(),
    this.page,
  });

  final ReaderStatus status;
  final BibleRef reference;
  final PageContent? page;

  ReaderState copyWith({
    ReaderStatus Function()? status,
    BibleRef Function()? reference,
    PageContent? Function()? page,
  }) {
    return ReaderState(
      status: status != null ? status() : this.status,
      reference: reference != null ? reference() : this.reference,
      page: page != null ? page() : this.page,
    );
  }

  @override
  List<Object?> get props => [
        status,
        reference,
        page,
      ];
}
