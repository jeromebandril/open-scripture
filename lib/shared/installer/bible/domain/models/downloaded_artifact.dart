import 'package:equatable/equatable.dart';

class DownloadedArtifact extends Equatable {
  final String path;
  final String displayName;

  const DownloadedArtifact({required this.path, required this.displayName});

  @override
  List<Object?> get props => [path, displayName];
}
