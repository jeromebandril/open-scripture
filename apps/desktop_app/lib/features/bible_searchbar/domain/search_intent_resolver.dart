import 'search_intent.dart';

class SearchIntentResolver {
  const SearchIntentResolver();

  SearchIntent resolve(String query) {
    if (int.tryParse(query) != null) {
      return VerseNumberIntent(verseNumber: int.parse(query));
    }
    return ReferenceIntent(rawQuery: query);
  }
}
