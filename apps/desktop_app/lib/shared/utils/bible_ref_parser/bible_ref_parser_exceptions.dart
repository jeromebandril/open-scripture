import '../../error/exception.dart';

class InvalidInputException extends AppException {
  const InvalidInputException(super.message, {super.cause, super.stackTrace});
}

class BibleRefInvalidFormatException extends InvalidInputException {
  const BibleRefInvalidFormatException(super.message);
}

class BibleRefInvalidNumberException extends InvalidInputException {
  const BibleRefInvalidNumberException(super.message);
}

class BibleRefOutOfRangeException extends InvalidInputException {
  const BibleRefOutOfRangeException(super.message);
}
