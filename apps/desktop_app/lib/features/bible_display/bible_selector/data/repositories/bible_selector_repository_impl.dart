import 'package:fpdart/fpdart.dart';
import 'package:open_scripture/core/infrastructure/bible_data/bible_datasource.dart';
import 'package:open_scripture/shared/entities/bible_meta.dart';
import 'package:open_scripture/features/bible_display/bible_selector/domain/repositories/bible_selector_repository.dart';

import '../../../../../shared/error/failure.dart';

class BibleSelectorRepositoryImpl implements BibleSelectorRepository {
  final BibleDataSource localDatasource;

  const BibleSelectorRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Failure, List<BibleMeta>>> getInstalledBibles() async {
    return Right(await localDatasource.getInstalledBibles());
  }
}
