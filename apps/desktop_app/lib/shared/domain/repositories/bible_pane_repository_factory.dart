import 'package:open_scripture/features/bible_display/bible_pane/domain/repositories/bible_pane_repository.dart';
import 'package:open_scripture/shared/enums/bible_repository_type.dart';

abstract interface class BibleRepositoryFactory {
  BiblePaneRepository get(BibleRepositoryType type);
}
