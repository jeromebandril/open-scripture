import '../../../../shared/error/failure.dart';

sealed class SearchFailure extends Failure {
  const SearchFailure({required super.message, super.cause, super.stackTrace});
}

class InvalidInputFailure extends Failure {
  const InvalidInputFailure({
    super.message = 'Invalid input',
    super.cause,
    super.stackTrace,
  });
}
