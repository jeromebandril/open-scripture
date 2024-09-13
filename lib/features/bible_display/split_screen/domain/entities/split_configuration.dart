import 'package:equatable/equatable.dart';

class SplitConfiguration extends Equatable {
  final List<int> horizontal;
  final List<int> vertical;

  const SplitConfiguration(
      {this.horizontal = const [], this.vertical = const []});

  @override
  List<Object?> get props => [horizontal, vertical];
}
