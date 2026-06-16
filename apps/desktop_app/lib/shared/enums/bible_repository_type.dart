enum BibleRepositoryType {
  localDatabase('Local Database'),
  sword('SWORD'),
  cloudAPI('Cloud API'),
  undefined('Undefined');

  const BibleRepositoryType(this.label);

  final String label;

  static const installableTypes = [
    BibleRepositoryType.localDatabase,
    BibleRepositoryType.sword,
  ];
}
