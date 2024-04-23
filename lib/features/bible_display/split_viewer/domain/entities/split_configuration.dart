import 'package:equatable/equatable.dart';

class SplitConfiguration extends Equatable {
  final int horizontal;
  final int vertical;

  const SplitConfiguration({this.horizontal = 0, this.vertical = 0});

  @override
  List<Object?> get props => [horizontal, vertical];
}
