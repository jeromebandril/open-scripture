sealed class SearchIntent {}

class ReferenceIntent extends SearchIntent {
  final String rawQuery;
  ReferenceIntent({required this.rawQuery});
}

class VerseNumberIntent extends SearchIntent {
  final int verseNumber;
  VerseNumberIntent({required this.verseNumber});
}

class StringSearchIntent extends SearchIntent {
  final String query;
  final List<int> bibleIds;
  StringSearchIntent({required this.query, required this.bibleIds});
}
