import 'package:equatable/equatable.dart';

enum InstallStage {
  idle,
  downloading,
  downloadingDone,
  installing,
  done,
  failed,
  canceled,
  paused
}

class InstallProgress extends Equatable {
  final InstallStage stage;
  final int received;
  final int total;
  final String? message;

  const InstallProgress({
    required this.stage,
    this.total = 0,
    this.received = 0,
    this.message,
  });

  double get fraction => total <= 0 ? 0.0 : received / total;

  InstallProgress copyWith({
    int Function()? total,
    int Function()? received,
    InstallStage Function()? stage,
  }) {
    return InstallProgress(
      total: total != null ? total() : this.total,
      received: received != null ? received() : this.received,
      stage: stage != null ? stage() : this.stage,
    );
  }

  @override
  List<Object?> get props => [
        stage,
        total,
        received,
        message,
      ];
}
