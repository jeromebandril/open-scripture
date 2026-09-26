import 'package:fpdart/fpdart.dart';

import '../../../../shared/error/failure.dart';
import '../../domain/entities/slide_data.dart';
import '../../domain/repositories/presenter_repository.dart';
import '../datasource/presenter_datasource.dart';

class PresenterRepositoryImpl extends PresenterRepository {
  final PresenterDatasource _datasource;

  PresenterRepositoryImpl({required PresenterDatasource datasource})
      : _datasource = datasource;

  @override
  TaskEither<Failure, List<SlideData>> restorePreviousSession() {
    return TaskEither.tryCatch(
      () => _datasource.load(),
      (error, st) => UnexpectedFailure(),
    );
  }

  @override
  TaskEither<Failure, void> saveSession({
    required List<SlideData> slides,
  }) {
    return TaskEither.tryCatch(
      () => _datasource.save(slides: slides),
      (error, st) => UnexpectedFailure(),
    );
  }
}
