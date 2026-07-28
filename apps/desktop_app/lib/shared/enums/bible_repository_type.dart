import 'package:flutter/foundation.dart';

enum BibleRepositoryType {
  localDatabase(
    label: 'Canonical',
    description:
        'Bibles installed in the local database, imported from compatible source files. Currently the only repository that support formatting decoration (red lettering, strong words etc...)',
  ),
  sword(
    label: 'Sword',
    description: 'Bibles modules for the Crosswire Sword Engine',
  ),
  cloudAPI(
    label: 'Get Bible v2',
    description:
        'Bibles from api.getbible.net/v2. Ready to go, doesn\'t require installation.',
  );

  const BibleRepositoryType({required this.label, this.description});

  final String label;
  final String? description;

  static const installableTypes = kIsWeb
      ? [
          BibleRepositoryType.localDatabase,
        ]
      : [
          BibleRepositoryType.localDatabase,
          BibleRepositoryType.sword,
        ];

  /// Central source of truth for platform capabilities.
  static const platformEnabled = kIsWeb
      ? [
          BibleRepositoryType.localDatabase,
          BibleRepositoryType.cloudAPI,
        ]
      : [
          BibleRepositoryType.localDatabase,
          BibleRepositoryType.sword,
          BibleRepositoryType.cloudAPI,
        ];

  // for GetIt registration
  bool get isAsyncRegistration => this == BibleRepositoryType.sword;
}
