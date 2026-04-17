import 'package:flutter/material.dart';
import '../../domain/models/app_command.dart';

@immutable
class AppCommandIntent extends Intent {
  const AppCommandIntent(this.command);
  final AppCommand command;
}
