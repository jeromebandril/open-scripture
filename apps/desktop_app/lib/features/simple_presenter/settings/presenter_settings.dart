import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../shared/utils/colors_util.dart';

class PresenterSettings extends Equatable {
  final Color textColor;
  final Color backgroundColor;
  final String gradientBackground;
  final bool useGradientBackground;
  final bool enableAutoNumbering;
  final int startNumberingFrom;

  const PresenterSettings({
    this.textColor = Colors.white,
    this.backgroundColor = Colors.blue,
    this.gradientBackground = "blue",
    this.useGradientBackground = true,
    this.enableAutoNumbering = true,
    this.startNumberingFrom = 2,
  });

  PresenterSettings copyWith({
    Color? textColor,
    Color? backgroundColor,
    String? gradientBackground,
    bool? useGradientBackground,
    bool? enableAutoNumbering,
    int? startNumberingFrom,
  }) {
    return PresenterSettings(
      textColor: textColor ?? this.textColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      gradientBackground: gradientBackground ?? this.gradientBackground,
      useGradientBackground:
          useGradientBackground ?? this.useGradientBackground,
      enableAutoNumbering: enableAutoNumbering ?? this.enableAutoNumbering,
      startNumberingFrom: startNumberingFrom ?? this.startNumberingFrom,
    );
  }

  factory PresenterSettings.fromJson(Map<String, dynamic> json) {
    final defaults = PresenterSettings();

    return PresenterSettings(
      textColor: json['textColor'] != null
          ? Color(ColorsUtil.parseHex(json['textColor'] as String))
          : defaults.textColor,
      backgroundColor: json['backgroundColor'] != null
          ? Color(ColorsUtil.parseHex(json['backgroundColor'] as String))
          : defaults.textColor,
      gradientBackground: json['gradientBackground'] != null
          ? json['gradientBackground'] as String
          : defaults.gradientBackground,
      useGradientBackground: json['useGradientBackground'] != null
          ? json['useGradientBackground'] as bool
          : defaults.enableAutoNumbering,
      enableAutoNumbering: json['enableAutoNumbering'] != null
          ? json['enableAutoNumbering'] as bool
          : defaults.enableAutoNumbering,
      startNumberingFrom: json['startNumberingFrom'] != null
          ? json['startNumberingFrom'] as int
          : defaults.startNumberingFrom,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'textColor': ColorsUtil.colorToHex(textColor),
      'backgroudColor': ColorsUtil.colorToHex(backgroundColor),
      'gradientBackground': gradientBackground,
      'useGradientBackground': useGradientBackground,
      'enableAutoNumbering': enableAutoNumbering,
      'startNumberingFrom': startNumberingFrom,
    };
  }

  @override
  List<Object?> get props => [
        textColor,
        backgroundColor,
        gradientBackground,
        useGradientBackground,
        enableAutoNumbering,
        startNumberingFrom,
      ];
}
