import '../../../features/bible_display/bible_pane/domain/repositories/bible_pane_repository.dart';
import '../../enums/bible_repository_type.dart';

abstract interface class BibleRepositoryFactory {
  Future<BiblePaneRepository> get(BibleRepositoryType type);
}
