import 'package:equatable/equatable.dart';

/// Base failure type for app-layer errors.
abstract class Failure extends Equatable {
  const Failure({
    required this.message,
    this.cause,
    this.stackTrace,
  });

  /// user-facing message (safe to display)
  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  @override
  List<Object?> get props => [message, cause, stackTrace];
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'An unexpected error happened',
    super.cause,
    super.stackTrace,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'A network connection error happened',
    super.cause,
    super.stackTrace,
  });
}
