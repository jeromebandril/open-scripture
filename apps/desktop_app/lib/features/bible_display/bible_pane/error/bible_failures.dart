import '../../../../shared/error/failure.dart';

sealed class BibleFailure extends Failure {
  const BibleFailure({
    required super.message,
    super.cause,
    super.stackTrace,
  });
}

final class ChapterUnavailableFailure extends BibleFailure {
  const ChapterUnavailableFailure({
    super.message = "This chapter isn't available in this translation",
    super.cause,
    super.stackTrace,
  });
}

final class BibleNotFoundFailure extends BibleFailure {
  const BibleNotFoundFailure({
    super.message = "Bible not found",
    super.cause,
    super.stackTrace,
  });
}

final class SwordUnavailableFailure extends BibleFailure {
  const SwordUnavailableFailure({
    super.message =
        'The Bible sword engine failed to load. Try restarting the app.',
    super.cause,
    super.stackTrace,
  });
}
