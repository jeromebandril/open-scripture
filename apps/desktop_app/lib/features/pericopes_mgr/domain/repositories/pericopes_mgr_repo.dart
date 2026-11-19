import 'package:fpdart/fpdart.dart';

import '../../../../shared/error/failure.dart';
import '../entities/pericope_set.dart';

abstract class PericopesMgrRepo {
  TaskEither<Failure, void> import(String path);
  TaskEither<Failure, void> removePericope(String extId);
  TaskEither<Failure, List<PericopeSet>> getInstalledPericopes();
}
