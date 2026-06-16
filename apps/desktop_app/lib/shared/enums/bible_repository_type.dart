enum BibleRepositoryType {
  localDatabase,
  sword,
  cloudAPI,
  undefined;

  static const installableTypes = [
    BibleRepositoryType.localDatabase,
    BibleRepositoryType.sword,
  ];
}
