import 'package:equatable/equatable.dart';

class Artifact extends Equatable {
  final String path;
  final String displayName;

  const Artifact({required this.path, required this.displayName});

  @override
  List<Object?> get props => [path, displayName];
}
