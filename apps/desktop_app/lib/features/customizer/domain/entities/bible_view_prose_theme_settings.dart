import 'package:equatable/equatable.dart';

class BibleViewProseThemeSettings extends Equatable {
  final bool emphasizeSelectedVerses;
  final double unselectedOpacityLevel;

  const BibleViewProseThemeSettings({
    this.emphasizeSelectedVerses = true,
    this.unselectedOpacityLevel = 0.43,
  });

  Map<String, dynamic> toJson() => {
        'emphasizeSelectedVerses': emphasizeSelectedVerses,
        'unselectedOpacityLevel': unselectedOpacityLevel,
      };

  BibleViewProseThemeSettings copyWith({
    bool? emphasizeSelectedVerses,
    double? unselectedOpacityLevel,
  }) {
    return BibleViewProseThemeSettings(
      emphasizeSelectedVerses:
          emphasizeSelectedVerses ?? this.emphasizeSelectedVerses,
      unselectedOpacityLevel:
          unselectedOpacityLevel ?? this.unselectedOpacityLevel,
    );
  }

  static BibleViewProseThemeSettings fromJson(Map<String, dynamic> json) {
    return BibleViewProseThemeSettings(
      emphasizeSelectedVerses: json['emphasizeSelectedVerses'] as bool,
      unselectedOpacityLevel: json['unselectedOpacityLevel'] as double,
    );
  }

  @override
  List<Object?> get props => [emphasizeSelectedVerses, unselectedOpacityLevel];
}
