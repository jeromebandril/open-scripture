import 'package:fpdart/fpdart.dart';
import 'package:open_scripture/shared/data/datasources/bible_catalog_datasource/bible_catalog_datasource.dart';
import 'package:open_scripture/shared/data/models/bible_install_dto.dart';
import 'package:open_scripture/shared/domain/entities/bible_translation.dart';
import 'package:open_scripture/shared/domain/repositories/bible_catalog_repository.dart';
import 'package:open_scripture/shared/error/failure.dart';

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
    String extId,
  ) async {
    try {
      final dto = await _dataSource.getBible(extId);
      return Right(dto.toDomain());
    } catch (e) {
      // TODO: implement proper failure
      return Left(UnknownFailure());
    }
  }
}
