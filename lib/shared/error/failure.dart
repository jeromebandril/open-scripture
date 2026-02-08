import 'package:equatable/equatable.dart';

/// Base failure type for app-layer errors.
///
/// Every failure carries:
/// - `details`: diagnostic string (loggable, can be shown in debug UI)
/// - `message`: user-facing summary (safe to display)
abstract class Failure extends Equatable {
  const Failure({this.details = '', this.stackTrace});

  final String details;
  final StackTrace? stackTrace;

  String get message;

  @override
  List<Object?> get props => [runtimeType, details];
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.details});

  @override
  String get message => 'Server error';
}

/// Rename suggestion: LocalCacheFailure
class NoLocalDataFailure extends Failure {
  const NoLocalDataFailure({super.details});

  @override
  String get message => 'No local data available';
}

class ResourceNotFoundFailure extends Failure {
  const ResourceNotFoundFailure({super.details});

  @override
  String get message => 'Not found';
}

class InstallFailure extends Failure {
  const InstallFailure({super.details});

  @override
  String get message => 'Installation failed';
}

/// Rename suggestion: MissingLoadedDataFailure
class MissingLoadedDataFailure extends Failure {
  const MissingLoadedDataFailure({super.details});

  @override
  String get message => 'No content loaded';
}

class PaneLayoutFailure extends Failure {
  const PaneLayoutFailure({super.details});

  @override
  String get message => 'Split operation not allowed';
}

class VerseMissingFailure extends Failure {
  const VerseMissingFailure({super.details});

  @override
  String get message => 'Verse does not exist';
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({super.details});

  @override
  String get message => 'Database error';
}

class DataCorruptionFailure extends Failure {
  const DataCorruptionFailure({super.details});

  @override
  String get message => 'Data is corrupted';
}

class PermissionFailure extends Failure {
  const PermissionFailure({super.details});

  @override
  String get message => 'Permission denied';
}

class InvalidInputFailure extends Failure {
  const InvalidInputFailure({super.details});

  @override
  String get message => 'Invalid input';
}

class ParseFailure extends Failure {
  const ParseFailure({super.details});

  @override
  String get message => 'Failed to parse data';
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({super.details});

  @override
  String get message => 'Operation timed out';
}

class CancelledFailure extends Failure {
  const CancelledFailure({super.details});

  @override
  String get message => 'Operation cancelled';
}

class UnknownFailure extends Failure {
  const UnknownFailure({super.details});

  @override
  String get message => 'Unknown';
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({super.details, super.stackTrace});

  @override
  String get message => 'Unexpected';
}
