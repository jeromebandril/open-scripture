import '../entities/bible_ref.dart';

/// A system-wide domain service for parsing arbitrary text annotations
/// into standardized Domain coordinate objects.
abstract class BibleRefParser {
  /// Parses a string like "1 John 3:16-18" or "Gen 1" into a [BibleRef].
  /// (Optional) [languageId] to correctly resolve localized book names.
  Future<BibleRef> parse(String rawReference, {int? languageId});
}
