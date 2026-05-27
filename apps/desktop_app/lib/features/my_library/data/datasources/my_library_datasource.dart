import 'package:open_scripture/shared/entities/bible_meta.dart';

// manage this in the dependency injection container
// export 'my_library_datasource_dektop_impl.dart'
//     if (dart.library.html) 'my_library_datasource_web_impl.dart';

abstract class MyLibraryDatasource {
  /// Returns the list of available bibles.
  ///
  /// This is a one-shot read (no live updates).
  Future<List<BibleMeta>> getBibles();

  /// Retrieves bible metadata for a specific bible using its id.
  ///
  /// Throws:
  /// - [NotFoundException] if the bible id does not exist
  Future<BibleMeta> getBible(Object id);

  /// Watches the list of available bibles and emits updates.
  Stream<List<BibleMeta>> watchBibles();
}
