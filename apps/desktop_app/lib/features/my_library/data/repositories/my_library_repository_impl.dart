import 'package:fpdart/fpdart.dart';
import 'package:open_scripture/features/my_library/data/datasources/my_library_datasource.dart';
import 'package:open_scripture/features/my_library/domain/repositories/my_library_repository.dart';
import 'package:open_scripture/shared/entities/bible_meta.dart';
import 'package:open_scripture/shared/error/failure.dart';

class MyLibraryRepositoryImpl implements MyLibraryRepository {
  const MyLibraryRepositoryImpl({required MyLibraryDatasource datasource})
      : _datasource = datasource;

  final MyLibraryDatasource _datasource;

  @override
  Future<Either<Failure, List<BibleMeta>>> getBibles() async {
    final bibles = await _datasource.getBibles();
    return Right(bibles);
  }

  @override
  Stream<List<BibleMeta>> watchBibles() {
    throw UnimplementedError();
  }
}
