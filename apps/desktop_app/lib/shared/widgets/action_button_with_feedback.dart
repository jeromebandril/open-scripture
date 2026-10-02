import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../design_system/design_system.dart';

// TODO: for now it just shows success feedback, implement also error

class ActionButtonWithFeedback extends StatefulWidget {
  const ActionButtonWithFeedback({
    super.key,
    required this.label,
    required this.successLabel,
    required this.onPressed,
    required this.buttonBuilder,
    this.icon,
  });

  final String label;
  final String successLabel;
  // final Text errorLabel;
  final VoidCallback onPressed;
  final ButtonStyleButton Function(
    VoidCallback? onPressed,
    Icon? icon,
    Text label,
  ) buttonBuilder;
  final Icon? icon;

  @override
  State<ActionButtonWithFeedback> createState() =>
      ActionButtonWithFeedbackState();
}

class ActionButtonWithFeedbackState extends State<ActionButtonWithFeedback> {
  // commented this because it is pratically instantenous
  // in all usecasess (for now)
  // bool _isExec = false;
  bool _showFeedback = false;
  Timer? _feedbackTimer;

  Future<void> _resetAssets() async {
    setState(() {
      // _isExec = true;
      _showFeedback = false;
    });
    widget.onPressed.call();

    setState(() {
      // _isExec = false;
      _showFeedback = true;
    });
    _feedbackTimer = Timer(const Duration(seconds: 2), () {
      setState(() => _showFeedback = false);
      _feedbackTimer = null;
    });
  }

  @override
  void dispose() {
    _feedbackTimer?.cancel();
    _feedbackTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final successColor = Theme.of(context).brightness == Brightness.light
        ? AppColors.success
        : AppColors.successDark;
    final successIcon = Icon(LucideIcons.circleCheckBig, color: successColor);
    final onPressed = _showFeedback ? null : () async => await _resetAssets();
    final icon =
        _showFeedback ? successIcon : const Icon(LucideIcons.rotateCcw);
    final label = _showFeedback
        ? Text(widget.successLabel, style: TextStyle(color: successColor))
        : Text(widget.label);

    return widget.buttonBuilder.call(onPressed, icon, label);
  }
}
