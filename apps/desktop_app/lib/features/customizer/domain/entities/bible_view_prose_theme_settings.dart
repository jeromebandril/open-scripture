import 'package:equatable/equatable.dart';

class BibleViewProseThemeSettings extends Equatable {
  final bool emphasizeSelectedVerses;

  const BibleViewProseThemeSettings({this.emphasizeSelectedVerses = true});

  Map<String, dynamic> toJson() => {
        'emphasizeSelectedVerses': emphasizeSelectedVerses,
      };

  BibleViewProseThemeSettings copyWith({
    bool? emphasizeSelectedVerses,
  }) {
    return BibleViewProseThemeSettings(
      emphasizeSelectedVerses:
          emphasizeSelectedVerses ?? this.emphasizeSelectedVerses,
    );
  }

  static BibleViewProseThemeSettings fromJson(Map<String, dynamic> json) {
    return BibleViewProseThemeSettings(
        emphasizeSelectedVerses: json['emphasizeSelectedVerses'] as bool);
  }

  @override
  List<Object?> get props => [emphasizeSelectedVerses];
}
