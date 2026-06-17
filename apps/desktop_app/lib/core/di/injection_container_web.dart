import 'package:get_it/get_it.dart';
import 'package:open_scripture/shared/data/services/book_resolvers/programmatic_book_resolver.dart';
import 'package:open_scripture/shared/domain/services/book_resolver.dart';

Future<void> init(GetIt sl) async {
  // Book resolver
  sl.registerLazySingleton<BookResolver>(() => ProgrammaticIdResolver());
}
