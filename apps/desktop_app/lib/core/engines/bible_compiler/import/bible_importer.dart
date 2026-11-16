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
abstract class BibleImporter {
  String get formatId;

  /// Quick capability check used by a registry/resolver to select the importer.
  Future<bool> canImport(SourcePackage package);

  /// Converts the external source package into the canonical model.
  ///
  /// Importers should:
  /// - populate [CanonicalBibleHeader]
  /// - add [PayloadIssue] for missing optional fields, unsupported tags, etc.
  Future<CanonicalBiblePackage> importFrom(SourcePackage package);

  /// Normalize strings such as Descriptions or Copyrights texts,
  /// because some metadata format these texts using tabs and other decorative characters
  String normalizeParagraphs(String input) {
    // 1. Standardize line endings to \n and replace non-breaking spaces (\u00A0) with normal spaces
    String cleaned = input.replaceAll('\r\n', '\n').replaceAll('\u00A0', ' ');

    // 2. Remove lines made purely of decorative characters (like =====)
    cleaned =
        cleaned.replaceAll(RegExp(r'^[=\-_]{3,}\s*$', multiLine: true), '');

    // 3. Split into paragraphs (separated by 2 or more newlines, accounting for whitespace on empty lines)
    List<String> paragraphs = cleaned.split(RegExp(r'\n\s*\n'));

    // 4. Inside each paragraph, collapse internal newlines and multiple spaces into a single space
    return paragraphs
        .map((p) => p.replaceAll(RegExp(r'\s+'), ' ').trim())
        .where((p) => p.isNotEmpty)
        .join('\n\n');
  }
}
