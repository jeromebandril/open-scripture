import 'package:flutter/foundation.dart';

enum BibleRepositoryType {
  localDatabase(
    label: 'Installed',
    description: 'Bibles installed in the local database',
  ),
  sword(
    label: 'Sword',
    description: 'Bibles modules for the Crosswire Sword Engine',
  ),
  cloudAPI(
    label: 'Get Bible v2',
    description: 'Bibles from api.getbible.net/v2',
  );

  const BibleRepositoryType({required this.label, this.description});

  final String label;
  final String? description;

  static const installableTypes = [
    BibleRepositoryType.localDatabase,
    BibleRepositoryType.sword,
  ];

  /// Central source of truth for platform capabilities.
  static const platformEnabled = kIsWeb
      ? [
          BibleRepositoryType.cloudAPI,
        ]
      : [
          BibleRepositoryType.localDatabase,
          BibleRepositoryType.sword,
          BibleRepositoryType.cloudAPI,
        ];

  bool get isAsyncRegistration => this == BibleRepositoryType.sword;
}
