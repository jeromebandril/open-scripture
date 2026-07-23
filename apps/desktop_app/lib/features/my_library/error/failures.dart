import '../../../../shared/error/failure.dart';

sealed class LibraryFailure extends Failure {
  const LibraryFailure({
    required super.message,
    super.cause,
    super.stackTrace,
  });
}

final class TranslationsNotLoadingFailure extends LibraryFailure {
  const TranslationsNotLoadingFailure({
    super.message = "Failed to load translations",
    super.cause,
    super.stackTrace,
  });
}
