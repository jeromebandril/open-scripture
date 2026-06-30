import 'package:fpdart/fpdart.dart';
import '../../../features/bible_importer/domain/entities/bible_importer_settings.dart';
import '../../error/failure.dart';

abstract class BibleImporterSettingsService {
  BibleImporterSettings get current;
  Future<void> initialize();
  Future<Either<Failure, void>> updatePath(String newPath);
}
