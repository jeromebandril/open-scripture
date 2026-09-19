import 'dart:convert';

class PericopeImportException implements Exception {
  PericopeImportException(this.problems);
  final List<String> problems;

  @override
  String toString() => 'PericopeImportException: ${problems.join('; ')}';
}

class PericopeEntry {
  const PericopeEntry({
    required this.title,
    required this.bookId,
    required this.startChapter,
    required this.startVerse,
    required this.endChapter,
    required this.endVerse,
  });

  final String title;
  final int bookId;
  final int startChapter, startVerse, endChapter, endVerse;
}

class _Ref {
  const _Ref(this.bookId, this.chapter, this.verse);
  final int bookId, chapter, verse;
}

class PericopeSetFile {
  const PericopeSetFile({
    required this.id,
    required this.name,
    required this.language,
    required this.version,
    required this.attribution,
    required this.entries,
  });

  final String id;
  final String name;
  final String language; // (isoCode)
  final int version;
  final String? attribution;
  final List<PericopeEntry> entries;

  static const supportedSchemaVersion = 1;
  static const _maxProblems = 10;
  static final _refPattern = RegExp(r'^([A-Za-z0-9]+)\.(\d+)\.(\d+)$');

  /// [bookIds] maps canonical_books.bookToken -> canonical_books.id.
  factory PericopeSetFile.parse(
    String source, {
    required Map<String, int> bookIds,
  }) {
    Object? root;
    try {
      root = jsonDecode(source);
    } on FormatException catch (e) {
      throw PericopeImportException(['Not valid JSON: ${e.message}']);
    }
    if (root is! Map<String, dynamic>) {
      throw PericopeImportException(['The top level must be a JSON object']);
    }
    final data = root;

    if (data['schemaVersion'] != supportedSchemaVersion) {
      throw PericopeImportException([
        'Unsupported schemaVersion ${data['schemaVersion']} '
            '(expected $supportedSchemaVersion)',
      ]);
    }

    final problems = <String>[];
    void report(String message) {
      if (problems.length < _maxProblems) problems.add(message);
    }

    String? requiredText(String key) {
      final v = data[key];
      if (v is String && v.trim().isNotEmpty) return v.trim();
      report('"$key" is required and must be a non-empty string');
      return null;
    }

    final id = requiredText('id');
    final name = requiredText('name');
    final language = requiredText('language')?.toLowerCase();

    final rawVersion = data['version'] ?? 1;
    var version = 1;
    if (rawVersion is int && rawVersion >= 1) {
      version = rawVersion;
    } else {
      report('"version" must be an integer >= 1');
    }

    final rawAttribution = data['attribution'];
    final attribution =
        rawAttribution is String && rawAttribution.trim().isNotEmpty
            ? rawAttribution.trim()
            : null;

    _Ref? parseRef(Object? raw) {
      if (raw is! String) return null;
      final m = _refPattern.firstMatch(raw.trim());
      if (m == null) return null;
      final bookId = bookIds[m.group(1)!];
      final chapter = int.parse(m.group(2)!);
      final verse = int.parse(m.group(3)!);
      if (bookId == null || chapter < 1 || verse < 1) return null;
      return _Ref(bookId, chapter, verse);
    }

    final entries = <PericopeEntry>[];
    final seenStarts = <String>{};
    final rawList = data['pericopes'];

    if (rawList is! List || rawList.isEmpty) {
      report('"pericopes" must be a non-empty array');
    } else {
      for (var i = 0; i < rawList.length; i++) {
        final at = 'pericopes[$i]';
        final item = rawList[i];

        if (item is! Map<String, dynamic>) {
          report('$at: must be an object');
          continue;
        }
        final title = item['title'];
        if (title is! String || title.trim().isEmpty) {
          report('$at: "title" is required');
          continue;
        }
        final start = parseRef(item['start']);
        final end = parseRef(item['end']);
        if (start == null || end == null) {
          report('$at ("$title"): invalid or unknown "start"/"end" reference '
              '(${item['start']} -> ${item['end']})');
          continue;
        }
        if (start.bookId != end.bookId) {
          report('$at ("$title"): start and end must be in the same book');
          continue;
        }
        final startsAfterEnd = start.chapter > end.chapter ||
            (start.chapter == end.chapter && start.verse > end.verse);
        if (startsAfterEnd) {
          report('$at ("$title"): start is after end');
          continue;
        }
        if (!seenStarts
            .add('${start.bookId}:${start.chapter}:${start.verse}')) {
          report('$at ("$title"): duplicate start ${item['start']}');
          continue;
        }

        entries.add(PericopeEntry(
          title: title.trim(),
          bookId: start.bookId,
          startChapter: start.chapter,
          startVerse: start.verse,
          endChapter: end.chapter,
          endVerse: end.verse,
        ));
      }
    }

    if (problems.isNotEmpty) throw PericopeImportException(problems);

    return PericopeSetFile(
      id: id!,
      name: name!,
      language: language!,
      version: version,
      attribution: attribution,
      entries: entries,
    );
  }
}
