import '../../../error/exception.dart';

class BibleRefInvalidFormatException extends AppException {
  const BibleRefInvalidFormatException(super.message);
}

class BibleRefInvalidNumberException extends AppException {
  const BibleRefInvalidNumberException(super.message);
}

class BibleRefOutOfRangeException extends AppException {
  const BibleRefOutOfRangeException(super.message);
}
