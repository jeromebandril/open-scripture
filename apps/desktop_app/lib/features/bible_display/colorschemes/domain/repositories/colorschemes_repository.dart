import '../entities/bible_view_colorscheme.dart';

abstract interface class ColorschemeRepository {
  Future<List<BibleViewColorscheme>> loadCustom();

  /// Creates or updates (matched by `name`).
  Future<void> save(BibleViewColorscheme scheme);

  Future<void> delete(String name);
}
