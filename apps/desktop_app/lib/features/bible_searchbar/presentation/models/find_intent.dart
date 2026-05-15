import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FindIntent extends Intent {
  const FindIntent();
}

class DollarActivator extends ShortcutActivator {
  const DollarActivator();

  @override
  bool accepts(KeyEvent event, HardwareKeyboard state) =>
      event is KeyDownEvent && event.character == r'$';

  @override
  String debugDescribeKeys() => r'$';
}
