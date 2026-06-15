enum BibleRepositoryType {
  installed,
  sword,
  onlineApi,
  undefined;

  static const installableTypes = [
    BibleRepositoryType.installed,
    BibleRepositoryType.sword,
  ];
}
