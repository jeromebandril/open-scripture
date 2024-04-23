import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();
}

class ServerFailure extends Failure {
  const ServerFailure();

  @override
  List<Object?> get props => [];
}

class NoLocalDataFailure extends Failure {
  const NoLocalDataFailure();

  @override
  List<Object?> get props => [];
}

class InstallFailure extends Failure {
  const InstallFailure();

  @override
  List<Object?> get props => [];
}

class NoLoadedDataFailure extends Failure {
  const NoLoadedDataFailure();

  @override
  List<Object?> get props => [];
}

class SplitFailure extends Failure {
  const SplitFailure();

  @override
  List<Object?> get props => [];
}
