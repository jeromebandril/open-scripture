import 'package:fpdart/fpdart.dart';
import 'package:open_scripture/shared/data/datasources/bible_sqllite_datasource.dart';
import 'package:open_scripture/shared/domain/entities/bible_meta.dart';
import 'package:open_scripture/features/bible_display/bible_selector/domain/repositories/bible_selector_repository.dart';

import '../../../../../shared/error/failure.dart';

class BibleSelectorRepositoryImpl implements BibleSelectorRepository {
  final BibleLocalDataSource localDatasource;

  const BibleSelectorRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Failure, List<BibleMeta>>> getInstalledBibles() async {
    return Right(await localDatasource.getInstalledBibles());
  }
}
