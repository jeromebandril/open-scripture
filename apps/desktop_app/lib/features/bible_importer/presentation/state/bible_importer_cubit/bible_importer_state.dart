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
    this.targetType = BibleRepositoryType.localDatabase,
  });

  final BibleImporterStatus status;
  final String? errorMessage;
  final InstallProgress? progress;
  final String? fileName;
  final BibleRepositoryType targetType;

  BibleImporterState copyWith({
    BibleImporterStatus? status,
    String? Function()? errorMessage,
    BibleRepositoryType? targetType,
    InstallProgress? progress,
    String? fileName,
  }) {
    return BibleImporterState(
      status: status ?? this.status,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      progress: progress ?? this.progress,
      fileName: fileName ?? this.fileName,
      targetType: targetType ?? this.targetType,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        progress,
        fileName,
        targetType,
      ];
}
