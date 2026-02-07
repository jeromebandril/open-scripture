import 'package:equatable/equatable.dart';

class BibleViewListThemeSettings extends Equatable {
  final bool underlineRef;

  const BibleViewListThemeSettings({
    this.underlineRef = false,
  });

  @override
  List<Object?> get props => [
        underlineRef,
      ];

  Map<String, dynamic> toJson() => {
        'underlineRef': underlineRef,
      };

  BibleViewListThemeSettings copyWith({bool? underlineRef}) {
    return BibleViewListThemeSettings(
      underlineRef: underlineRef ?? this.underlineRef,
    );
  }

  static BibleViewListThemeSettings fromJson(Map<String, dynamic> json) {
    return BibleViewListThemeSettings(
      underlineRef: json['underlineRef'] as bool,
    );
  }
}
