import 'package:get_it/get_it.dart';

import '../../shared/enums/bible_repository_type.dart';

extension ResolveByBibleType on GetIt {
  /// Resolves [T] under `type.name` regardless of whether that
  /// particular type happens to be registered sync or async.
  /// This way, calls never branch on get/getAsync again.
  Future<T> resolve<T extends Object>(BibleRepositoryType type) async {
    return type.isAsyncRegistration
        ? await getAsync<T>(instanceName: type.name)
        : get<T>(instanceName: type.name);
  }
}
