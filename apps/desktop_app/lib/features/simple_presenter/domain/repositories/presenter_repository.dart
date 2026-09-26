import 'package:fpdart/fpdart.dart';

import '../../../../shared/error/failure.dart';
import '../entities/slide_data.dart';

abstract class PresenterRepository {
  TaskEither<Failure, List<SlideData>> restorePreviousSession();
  TaskEither<Failure, void> saveSession({
    required List<SlideData> slides,
  });
}
