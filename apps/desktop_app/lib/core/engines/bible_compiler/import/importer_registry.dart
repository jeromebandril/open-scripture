import '../source/packages/source_package.dart';
import 'bible_importer.dart';

/// Resolves the correct importer for a [SourcePackage].
final class ImporterRegistry {
  final List<BibleImporter> _importers;

  const ImporterRegistry(this._importers);

  /// Returns the first importer that claims it can import the given package.
  /// Throws if none match.
  Future<BibleImporter> resolve(SourcePackage package) async {
    for (final importer in _importers) {
      final ok = await importer.canImport(package);
      if (ok) return importer;
    }
    final entryCount = SourcePackage is ContainerPackage
        ? ((package as ContainerPackage).listEntries()).length
        : 1;
    throw UnsupportedFormatException(
      displayName: package.displayName,
      entryCount: entryCount,
      knownFormats: _importers.map((i) => i.formatId).toList(growable: false),
    );
  }
}

final class UnsupportedFormatException implements Exception {
  final String displayName;
  final int entryCount;
  final List<String> knownFormats;

  const UnsupportedFormatException({
    required this.displayName,
    required this.entryCount,
    required this.knownFormats,
  });

  @override
  String toString() => 'UnsupportedFormatException(displayName=$displayName, '
      'entryCount=$entryCount, knownFormats=$knownFormats)';
}
