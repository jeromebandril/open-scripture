import 'package:equatable/equatable.dart';

class BibleViewSettings extends Equatable {
  final bool enableAutoScrollToVerse;

  const BibleViewSettings({
    this.enableAutoScrollToVerse = true,
  });

  BibleViewSettings copyWith({
    bool? enableAutoScrollToVerse,
  }) {
    return BibleViewSettings(
      enableAutoScrollToVerse:
          enableAutoScrollToVerse ?? this.enableAutoScrollToVerse,
    );
  }

  factory BibleViewSettings.fromJson(Map<String, dynamic> json) {
    return BibleViewSettings(
      enableAutoScrollToVerse:
          json['enableAutoScrollToVerse'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enableAutoScrollToVerse': enableAutoScrollToVerse,
    };
  }

  @override
  List<Object?> get props => [enableAutoScrollToVerse];
}
