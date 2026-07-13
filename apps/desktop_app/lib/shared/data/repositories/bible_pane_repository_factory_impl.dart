import '../../../features/bible_display/bible_pane/domain/repositories/bible_pane_repository.dart';
import '../../domain/repositories/bible_pane_repository_factory.dart';
import '../../enums/bible_repository_type.dart';

class BibleRepositoryFactoryImpl implements BibleRepositoryFactory {
  final Map<BibleRepositoryType, Future<BiblePaneRepository> Function()>
      _builders;

  BibleRepositoryFactoryImpl(this._builders);

  @override
  Future<BiblePaneRepository> get(BibleRepositoryType type) {
    final builder = _builders[type];
    if (builder == null) {
      throw ArgumentError('No repository registered for $type');
    }
    return builder();
  }
}
