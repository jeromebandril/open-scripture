import 'package:fpdart/fpdart.dart';
import 'package:the_smyrna_bible_v2/core/data/datasources/bible_sqllite_datasource.dart';
import 'package:the_smyrna_bible_v2/core/domain/entities/bible_meta.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_selector/domain/repositories/bible_selector_repository.dart';

import '../../../../../core/error/failure.dart';

class BibleSelectorRepositoryImpl implements BibleSelectorRepository {
  final BibleLocalDataSource localDatasource;

  const BibleSelectorRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Failure, List<BibleMeta>>> getInstalledBibles() async {
    return Right(await localDatasource.getInstalledBibles());
  }
}
