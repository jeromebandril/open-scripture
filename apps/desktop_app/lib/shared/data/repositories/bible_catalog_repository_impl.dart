import 'package:fpdart/fpdart.dart';

import '../../domain/entities/bible_id.dart';
import '../../domain/entities/bible_translation.dart';
import '../../domain/repositories/bible_catalog_repository.dart';
import '../../error/failure.dart';
import '../datasources/bible_catalog_datasource/bible_catalog_datasource.dart';
import '../models/bible_install_dto.dart';

class BibleCatalogRepositoryImpl implements BibleCatalogRepository {
  final BibleCatalogDatasource _dataSource;

  BibleCatalogRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<BibleTranslation>>> getAvailableBibles() async {
    try {
      final dtos = await _dataSource.getBibles();
      return Right(dtos.map((dto) => dto.toDomain()).toList());
    } catch (e) {
      // TODO: implement proper failure
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, BibleTranslation>> getBibleDetails(
    BibleId bibleId,
  ) async {
    try {
      final dto = await _dataSource.getBible(bibleId.externalId);
      return Right(dto.toDomain());
    } catch (e) {
      // TODO: implement proper failure
      return Left(UnknownFailure());
    }
  }
}
