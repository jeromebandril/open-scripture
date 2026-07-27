/// Base class for all app-specific exceptions thrown by data sources.
abstract class AppException implements Exception {
  const AppException(this.message, {this.cause, this.stackTrace});

  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  @override
  String toString() => '$runtimeType: $message';
}

class ServerException extends AppException {
  final int? statusCode;

  const ServerException(super.message, {this.statusCode});
}

class NetworkException extends AppException {
  const NetworkException(super.details);
}

class SwordException extends AppException {
  const SwordException(super.message, {super.cause, super.stackTrace});
}

class ParseException extends AppException {
  const ParseException(super.details);
}

class DatabaseException extends AppException {
  const DatabaseException(super.details);
}

class NotFoundException extends AppException {
  const NotFoundException(super.details);
}

// Install pipeline exceptions
class InstallFileMissingException extends AppException {
  const InstallFileMissingException(super.message,
      {super.cause, super.stackTrace});
}

class InstallZipDecodeException extends AppException {
  const InstallZipDecodeException(super.message,
      {super.cause, super.stackTrace});
}

class InstallArchiveContentException extends AppException {
  const InstallArchiveContentException(super.message,
      {super.cause, super.stackTrace});
}

class InstallParseException extends AppException {
  const InstallParseException(super.message, {super.cause, super.stackTrace});
}

class InstallDatabaseException extends AppException {
  const InstallDatabaseException(super.message,
      {super.cause, super.stackTrace});
}

class InstallCleanupException extends AppException {
  const InstallCleanupException(super.message, {super.cause, super.stackTrace});
}

class UninstallationException extends AppException {
  const UninstallationException(super.message, {super.cause, super.stackTrace});
}

class UninstallNotFoundException extends AppException {
  const UninstallNotFoundException(super.message,
      {super.cause, super.stackTrace});
}

class LocalDataException extends AppException {
  const LocalDataException(
    super.message, {
    super.cause,
    super.stackTrace,
  });
}

class DownloadException extends AppException {
  const DownloadException(
    super.message, {
    super.cause,
    super.stackTrace,
  });
}
