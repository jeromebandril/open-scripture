import 'package:equatable/equatable.dart';

import 'domain/entities/searchbar_appearance_option.dart';

class SearchSettings extends Equatable {
  final bool enableBookSuggestion;
  final SearchbarAppearanceOption searchbarAppearance;

  const SearchSettings({
    this.enableBookSuggestion = true,
    this.searchbarAppearance = SearchbarAppearanceOption.normal,
  });

  SearchSettings copyWith({
    bool? enableBookSuggestion,
    SearchbarAppearanceOption? searchbarAppearance,
  }) {
    return SearchSettings(
      enableBookSuggestion: enableBookSuggestion ?? this.enableBookSuggestion,
      searchbarAppearance: searchbarAppearance ?? this.searchbarAppearance,
    );
  }

  factory SearchSettings.fromJson(Map<String, dynamic> json) {
    return SearchSettings(
      enableBookSuggestion: json['enableBookSuggestion'] as bool? ?? false,
      searchbarAppearance: json['searchbarAppearance'] != null
          ? SearchbarAppearanceOption.values
              .byName(json['searchbarAppearance'] as String)
          : SearchbarAppearanceOption.normal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enableBookSuggestion': enableBookSuggestion,
      'searchbarAppearance': searchbarAppearance.name,
    };
  }

  @override
  List<Object?> get props => [
        enableBookSuggestion,
        searchbarAppearance,
      ];
}
