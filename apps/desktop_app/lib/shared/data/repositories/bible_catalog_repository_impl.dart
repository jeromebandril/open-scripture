import 'package:fpdart/fpdart.dart';

import '../../../features/my_library/error/failures.dart';
import '../../domain/entities/bible_id.dart';
import '../../domain/entities/bible_translation.dart';
import '../../domain/repositories/bible_catalog_repository.dart';
import '../../error/exception.dart';
import '../../error/failure.dart';
import '../datasources/bible_catalog_datasource/bible_catalog_datasource.dart';
import '../models/bible_install_dto.dart';

class BibleCatalogRepositoryImpl implements BibleCatalogRepository {
  final BibleCatalogDatasource _dataSource;

  BibleCatalogRepositoryImpl(this._dataSource);

  @override
  TaskEither<Failure, List<BibleTranslation>> getAvailableBibles() {
    return TaskEither.tryCatch(() async {
      final dtos = await _dataSource.getBibles();
      return dtos.map((dto) => dto.toDomain()).toList();
    },
        (error, st) => switch (error) {
              NetworkException e => NetworkFailure(cause: e, stackTrace: st),
              ServerException e =>
                TranslationsNotLoadingFailure(cause: e, stackTrace: st),
              _ => UnexpectedFailure(cause: error, stackTrace: st),
            });
  }

  @override
  TaskEither<Failure, BibleTranslation> getBibleDetails(
    BibleId bibleId,
  ) {
    return TaskEither.tryCatch(
        () async => (await _dataSource.getBible(bibleId.externalId)).toDomain(),
        (error, st) => switch (error) {
              NetworkException e => NetworkFailure(cause: e, stackTrace: st),
              ServerException e =>
                TranslationsNotLoadingFailure(cause: e, stackTrace: st),
              _ => UnexpectedFailure(cause: error, stackTrace: st),
            });
  }
}
