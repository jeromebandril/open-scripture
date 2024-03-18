import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/translation_info.dart';

abstract class TranslationManagerRepository {
  Stream<Either<Failure, List<int>>> downloadTranslation(String id);

  Future<dynamic> installTranslation(String path);

  Future<dynamic> uninstallTranslation(String id);

  Stream<Either<Failure, List<TranslationInfo>>> getInstalledTranslationList();

  Stream<Either<Failure, List<TranslationInfo>>> getAllTranslationsList();
}
