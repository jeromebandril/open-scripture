import 'package:equatable/equatable.dart';

class SearchSettings extends Equatable {
  final bool enableBookSuggestion;

  const SearchSettings({this.enableBookSuggestion = true});

  SearchSettings copyWith({
    bool? enableBookSuggestion,
  }) {
    return SearchSettings(
      enableBookSuggestion: enableBookSuggestion ?? this.enableBookSuggestion,
    );
  }

  factory SearchSettings.fromJson(Map<String, dynamic> json) {
    return SearchSettings(
      enableBookSuggestion: json['enableBookSuggestion'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enableBookSuggestion': enableBookSuggestion,
    };
  }

  @override
  List<Object?> get props => [enableBookSuggestion];
}
