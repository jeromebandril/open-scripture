import 'package:equatable/equatable.dart';
import 'package:open_scripture/shared/installer/bible/domain/models/artifact.dart';

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

  final Artifact? artifact;

  const InstallProgress({
    required this.stage,
    this.total = 0,
    this.received = 0,
    this.message,
    this.artifact,
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
        artifact,
      ];
}
