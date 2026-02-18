import '../domain/models/canonical_bible_package.dart';
import '../source/packages/source_package.dart';

/// Contract implemented by each supported Bible format importer (OSIS, USFX, ...).
///
/// Importers:
/// - MUST NOT touch filesystem paths, HTTP, temp dirs, or zip extraction.
/// - MUST read input exclusively via [SourcePackage].
/// - MUST output ONLY your canonical data model: [CanonicalBiblePackage].
///
/// Throw only when the format is not supported / cannot be imported at all.
/// For recoverable problems, emit [PayloadIssue] inside the returned package.
abstract interface class BibleImporter {
  String get formatId;

  /// Quick capability check used by a registry/resolver to select the importer.
  Future<bool> canImport(SourcePackage package);

  /// Converts the external source package into the canonical model.
  ///
  /// Importers should:
  /// - populate [CanonicalBibleHeader]
  /// - add [PayloadIssue] for missing optional fields, unsupported tags, etc.
  Future<CanonicalBiblePackage> importFrom(SourcePackage package);
}
