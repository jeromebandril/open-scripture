class PericopeImportException implements Exception {
  PericopeImportException(this.problems);
  final List<String> problems;

  @override
  String toString() => 'PericopeImportException: ${problems.join('; ')}';
}
