import 'package:fpdart/fpdart.dart';
import 'package:open_scripture/shared/entities/bible_meta.dart';
import 'package:open_scripture/shared/error/failure.dart';

abstract class MyLibraryRepository {
  Future<Either<Failure, List<BibleMeta>>> getBibles();
  Stream<List<BibleMeta>> watchBibles();
}
