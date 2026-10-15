import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../../../shared/utils/colors_util.dart';

abstract class _Keys {
  static const name = 'name';
  static const label = 'label';
  static const backgroundColor = 'backgroundColor';
  static const verseColor = 'verseColor';
  static const refColor = 'refColor';
  static const selectedRefColor = 'selectedRefColor';
  static const quoteColor = 'quoteColor';
  static const addColor = 'addColor';
  static const strongWordsUnderlineColor = 'strongWordsUnderlineColor';
  static const pericopeColor = 'pericopeColor';
  static const verseDividerColor = 'verseDividerColor';
}

/// Every color of the Bible view, detached from BibleViewSettings.
///
/// BibleViewSettings only stores the [name] of the colorscheme to use.
class BibleViewColorscheme extends Equatable {
  static const defaultLightName = 'defaultLight';
  static const defaultDarkName = 'defaultDark';
  static const customPrefix = 'custom_';

  /// Unique key. This is what BibleViewSettings persists.
  /// Presets use fixed names ('midnight'); custom ones get [generateName].
  final String name;

  /// Text shown in the UI. Can be renamed without breaking references.
  final String label;

  final Color backgroundColor;
  final Color verseColor;
  final Color refColor;
  final Color selectedRefColor;
  final Color quoteColor;
  final Color addColor;
  final Color strongWordsUnderlineColor;
  final Color pericopeColor;
  final Color verseDividerColor;

  const BibleViewColorscheme({
    required this.name,
    required this.label,
    required this.backgroundColor,
    required this.verseColor,
    required this.refColor,
    required this.selectedRefColor,
    required this.quoteColor,
    required this.addColor,
    required this.strongWordsUnderlineColor,
    required this.pericopeColor,
    required this.verseDividerColor,
  });

  // Built-in defaults (also the fallback when a name matches nothing)
  static const defaultLight = BibleViewColorscheme(
    name: defaultLightName,
    label: 'Default Light',
    backgroundColor: Color(0xFFF0F0F0),
    verseColor: Color(0xFF0C0C0C),
    refColor: Color(0xFF81811E),
    selectedRefColor: Color(0xFF7222DA),
    quoteColor: Color(0xFFE04A4A),
    addColor: Color(0xFF858585),
    strongWordsUnderlineColor: Color(0x42000000),
    pericopeColor: Color(0xFF0C0C0C),
    verseDividerColor: Color(0xFFCCCCCC),
  );

  static const defaultDark = BibleViewColorscheme(
    name: defaultDarkName,
    label: 'Default Dark',
    backgroundColor: Color(0xFF0C0C0C),
    verseColor: Color(0xFFB9B9B9),
    refColor: Color(0xFF81811E),
    selectedRefColor: Color(0xFFA390FF),
    quoteColor: Color(0xFFE04A4A),
    addColor: Color(0xFFD2D2D2),
    strongWordsUnderlineColor: Color(0x42000000),
    pericopeColor: Color(0xFFB9B9B9),
    verseDividerColor: Color(0xFF333333),
  );

  Brightness get brightness =>
      ThemeData.estimateBrightnessForColor(backgroundColor);
  bool get isDark => brightness == Brightness.dark;
  bool get isCustom => name.startsWith(customPrefix);

  /// Random unique name for a new custom colorscheme, e.g. `custom_3fa91c`.
  static String generateName() {
    final random = Random.secure();
    final suffix =
        List.generate(6, (_) => random.nextInt(16).toRadixString(16)).join();
    return '$customPrefix$suffix';
  }

  /// Finds a colorscheme by [name] in [available] (presets + custom ones).
  /// Falls back to [defaultLight] when nothing matches.
  static BibleViewColorscheme resolve(
    String name,
    Iterable<BibleViewColorscheme> available,
  ) {
    for (final scheme in available) {
      if (scheme.name == name) return scheme;
    }
    return defaultLight;
  }

  /// A copy of this colorscheme as a brand new custom one (new generated
  /// name). Use it to fork a preset when the user edits one of its colors.
  BibleViewColorscheme asNewCustom({String? label}) {
    final newName = generateName();
    return copyWith(name: newName, label: label ?? newName);
  }

  BibleViewColorscheme copyWith({
    String? name,
    String? label,
    Color? backgroundColor,
    Color? verseColor,
    Color? refColor,
    Color? selectedRefColor,
    Color? quoteColor,
    Color? addColor,
    Color? strongWordsUnderlineColor,
    Color? pericopeColor,
    Color? verseDividerColor,
  }) {
    return BibleViewColorscheme(
      name: name ?? this.name,
      label: label ?? this.label,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      verseColor: verseColor ?? this.verseColor,
      refColor: refColor ?? this.refColor,
      selectedRefColor: selectedRefColor ?? this.selectedRefColor,
      quoteColor: quoteColor ?? this.quoteColor,
      addColor: addColor ?? this.addColor,
      strongWordsUnderlineColor:
          strongWordsUnderlineColor ?? this.strongWordsUnderlineColor,
      pericopeColor: pericopeColor ?? this.pericopeColor,
      verseDividerColor: verseDividerColor ?? this.verseDividerColor,
    );
  }

  Map<String, dynamic> toJson() => {
        _Keys.name: name,
        _Keys.label: label,
        _Keys.backgroundColor: ColorsUtil.colorToHex(backgroundColor),
        _Keys.verseColor: ColorsUtil.colorToHex(verseColor),
        _Keys.refColor: ColorsUtil.colorToHex(refColor),
        _Keys.selectedRefColor: ColorsUtil.colorToHex(selectedRefColor),
        _Keys.quoteColor: ColorsUtil.colorToHex(quoteColor),
        _Keys.addColor: ColorsUtil.colorToHex(addColor),
        _Keys.strongWordsUnderlineColor:
            ColorsUtil.colorToHex(strongWordsUnderlineColor),
        _Keys.pericopeColor: ColorsUtil.colorToHex(pericopeColor),
        _Keys.verseDividerColor: ColorsUtil.colorToHex(verseDividerColor),
      };

  factory BibleViewColorscheme.fromJson(Map<String, dynamic> json) {
    const d = BibleViewColorscheme.defaultLight;
    final name = json[_Keys.name] as String;

    return BibleViewColorscheme(
      name: name,
      label: json[_Keys.label] as String? ?? name,
      backgroundColor: _color(json[_Keys.backgroundColor], d.backgroundColor),
      verseColor: _color(json[_Keys.verseColor], d.verseColor),
      refColor: _color(json[_Keys.refColor], d.refColor),
      selectedRefColor:
          _color(json[_Keys.selectedRefColor], d.selectedRefColor),
      quoteColor: _color(json[_Keys.quoteColor], d.quoteColor),
      addColor: _color(json[_Keys.addColor], d.addColor),
      strongWordsUnderlineColor: _color(
          json[_Keys.strongWordsUnderlineColor], d.strongWordsUnderlineColor),
      pericopeColor: _color(json[_Keys.pericopeColor], d.pericopeColor),
      verseDividerColor:
          _color(json[_Keys.verseDividerColor], d.verseDividerColor),
    );
  }

  static Color _color(Object? hex, Color fallback) =>
      hex is String ? Color(ColorsUtil.parseHex(hex)) : fallback;

  @override
  List<Object?> get props => [
        name,
        label,
        backgroundColor,
        verseColor,
        refColor,
        selectedRefColor,
        quoteColor,
        addColor,
        strongWordsUnderlineColor,
        pericopeColor,
        verseDividerColor,
      ];
}
