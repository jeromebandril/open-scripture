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

  static const selectable = [
    BibleRepositoryType.localDatabase,
    BibleRepositoryType.sword,
    BibleRepositoryType.cloudAPI,
  ];
}
