import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/translation_info.dart';

abstract class TranslationManagerRepository {
  Future<Either<Failure, Stream<List<int>>>> downloadTranslation(String id);

  Future<void> installTranslation(String id);

  Future<dynamic> uninstallTranslation(String id);

  Stream<Either<Failure, List<TranslationInfo>>> getInstalledTranslationList();

  Stream<Either<Failure, List<TranslationInfo>>> getAllTranslationsList();
}
