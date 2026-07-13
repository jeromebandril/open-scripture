import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

List<String> shortcutTokens(ShortcutActivator? activator) {
  if (activator == null) return const [];

  final tokens = <String>[];

  if (activator is SingleActivator) {
    // Modifiers in conventional display order
    if (activator.control) {
      tokens.add(_modifierLabel(ModifierKey.controlModifier));
    }
    if (activator.alt) tokens.add(_modifierLabel(ModifierKey.altModifier));
    if (activator.shift) tokens.add(_modifierLabel(ModifierKey.shiftModifier));
    if (activator.meta) tokens.add(_modifierLabel(ModifierKey.metaModifier));

    tokens.add(_keyLabel(activator.trigger));

    return tokens;
  } else if (activator is CharacterActivator) {
    // CharacterActivator doesn't have a 'shift' property because the shift
    // requirement is inherently part of the character itself.
    if (activator.control) {
      tokens.add(_modifierLabel(ModifierKey.controlModifier));
    }
    if (activator.alt) tokens.add(_modifierLabel(ModifierKey.altModifier));
    if (activator.meta) tokens.add(_modifierLabel(ModifierKey.metaModifier));

    tokens.add(activator.character.toUpperCase());

    return tokens;
  }

  return const ['(Unsupported)'];
}

enum ModifierKey { controlModifier, altModifier, shiftModifier, metaModifier }

String _modifierLabel(ModifierKey key) {
  final isApple = defaultTargetPlatform.name == 'macOS';

  switch (key) {
    case ModifierKey.controlModifier:
      return 'Ctrl';
    case ModifierKey.shiftModifier:
      return 'Shift';
    case ModifierKey.altModifier:
      return isApple ? 'Option' : 'Alt';
    case ModifierKey.metaModifier:
      return isApple ? 'Cmd' : 'Meta';
  }
}

String _keyLabel(LogicalKeyboardKey key) {
  // Common special keys and exceptions
  if (key == LogicalKeyboardKey.escape) return 'Esc';
  if (key == LogicalKeyboardKey.enter) return 'Enter';
  if (key == LogicalKeyboardKey.space) return 'Space';
  if (key == LogicalKeyboardKey.tab) return 'Tab';
  if (key == LogicalKeyboardKey.backspace) return 'Backspace';
  if (key == LogicalKeyboardKey.delete) return 'Delete';

  if (key == LogicalKeyboardKey.arrowUp) return '↑';
  if (key == LogicalKeyboardKey.arrowDown) return '↓';
  if (key == LogicalKeyboardKey.arrowLeft) return '←';
  if (key == LogicalKeyboardKey.arrowRight) return '→';

  if (key == LogicalKeyboardKey.equal) return '+';

  // Letters/digits are usually good via keyLabel.
  final label = key.keyLabel;
  if (label.isNotEmpty) return label.length == 1 ? label.toUpperCase() : label;

  // F-keys often have empty keyLabel; derive from debugName when possible.
  final dn = key.debugName ?? '';
  if (dn.startsWith('F') && dn.length <= 3) return dn; // F1..F12 typical

  return key.debugName ?? 'Key';
}
