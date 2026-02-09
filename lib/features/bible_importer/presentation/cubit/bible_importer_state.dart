part of 'bible_importer_cubit.dart';

enum BibleImporterStatus {
  initial,
  failed,
  running,
  succeed,
}

class BibleImporterState extends Equatable {
  const BibleImporterState({
    this.status = BibleImporterStatus.initial,
    this.errorMessage,
    this.progress,
    this.fileName,
  });

  final BibleImporterStatus status;
  final String? errorMessage;
  final InstallProgress? progress;
  final String? fileName;

  BibleImporterState copyWith({
    BibleImporterStatus? status,
    String? errorMessage,
    InstallProgress? progress,
    String? fileName,
  }) {
    return BibleImporterState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      progress: progress ?? this.progress,
      fileName: fileName ?? this.fileName,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        progress,
        fileName,
      ];
}
