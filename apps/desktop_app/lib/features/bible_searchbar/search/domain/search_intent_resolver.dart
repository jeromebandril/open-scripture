import 'entities/search_intent.dart';

class SearchIntentResolver {
  const SearchIntentResolver();

  SearchIntent resolve(String query) {
    if (int.tryParse(query) != null) {
      return VerseNumberIntent(verseNumber: int.parse(query));
    }
    if (query.contains(';')) {
      return MultipleReferenceIntent(rawQueries: query.split(';'));
    }
    return ReferenceIntent(rawQuery: query);
  }
}
