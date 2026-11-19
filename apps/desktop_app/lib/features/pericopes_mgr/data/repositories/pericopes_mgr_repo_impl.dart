import 'package:fpdart/fpdart.dart';

import '../../../../shared/data/datasources/pericope_datasource.dart';
import '../../../../shared/data/services/pericope_importer.dart';
import '../../../../shared/error/failure.dart';
import '../../domain/entities/pericope_set.dart';
import '../../domain/repositories/pericopes_mgr_repo.dart';
import '../../error/pericopes_mgr_exceptions.dart';

class PericopesMgrRepoImpl implements PericopesMgrRepo {
  final PericopeDatasource _datasource;
  final PericopeImporter _importer;

  PericopesMgrRepoImpl({
    required PericopeDatasource datasource,
    required PericopeImporter importer,
  })  : _importer = importer,
        _datasource = datasource;

  @override
  TaskEither<Failure, void> import(String path) {
    return TaskEither.tryCatch(
      () async => await _importer.importUserFile(path),
      (error, st) => switch (error) {
        PericopeImportException e =>
          UnexpectedFailure(cause: e, stackTrace: st),
        _ => UnexpectedFailure(cause: error, stackTrace: st),
      },
    );
  }

  @override
  TaskEither<Failure, List<PericopeSet>> getInstalledPericopes() {
    return TaskEither.tryCatch(
      () async => await _datasource.getAllPericopeSets(),
      (error, st) => switch (error) {
        _ => UnexpectedFailure(cause: error, stackTrace: st),
      },
    );
  }

  @override
  TaskEither<Failure, void> removePericope(String extId) {
    return TaskEither.tryCatch(
      () async => await _datasource.deletePericopeSet(extId),
      (error, st) => switch (error) {
        PericopeImportException e =>
          UnexpectedFailure(cause: e, stackTrace: st),
        _ => UnexpectedFailure(cause: error, stackTrace: st),
      },
    );
  }
}
