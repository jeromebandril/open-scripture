import 'package:open_scripture/features/bible_display/bible_pane/domain/repositories/bible_pane_repository.dart';
import 'package:open_scripture/shared/domain/repositories/bible_pane_repository_factory.dart';
import 'package:open_scripture/shared/enums/bible_repository_type.dart';

class BibleRepositoryFactoryImpl implements BibleRepositoryFactory {
  final Map<BibleRepositoryType, BiblePaneRepository Function()> _builders;

  BibleRepositoryFactoryImpl(this._builders);

  @override
  BiblePaneRepository get(BibleRepositoryType type) {
    final builder = _builders[type];
    if (builder == null) {
      throw ArgumentError('No repository registered for $type');
    }
    return builder();
  }
}
