import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../settings_window/presentation/models/settings_route.dart';
import '../../../settings_window/presentation/pages/settings_window.dart';
import '../../../window_stack_manager/presentation/bloc/window_stack_manager_bloc.dart';

class Toolbar extends StatelessWidget {
  const Toolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(children: [
        ToolbarOption(
          'Bible',
          onTap: () {
            context.read<WindowStackManagerBloc>().add(
                  WindowStackManagerOpen(
                    SettingsWindow(
                      initialRoute: SettingsSection.bibleManager,
                      onClose: () {
                        context
                            .read<WindowStackManagerBloc>()
                            .add(WindowStackManagerClose());
                      },
                    ),
                  ),
                );
          },
        ),
        const ToolbarOption('Options'),
        const ToolbarOption('Tools'),
        ToolbarOption(
          'Help',
          onTap: () {
            context.read<WindowStackManagerBloc>().add(
                  WindowStackManagerOpen(
                    SettingsWindow(
                      initialRoute: SettingsSection.about,
                      onClose: () {
                        context
                            .read<WindowStackManagerBloc>()
                            .add(WindowStackManagerClose());
                      },
                    ),
                  ),
                );
          },
        ),
      ]),
    );
  }
}

class ToolbarOption extends StatefulWidget {
  final String text;
  final List<ToolbarOption>? subOptions;
  final Function()? onTap;

  const ToolbarOption(
    this.text, {
    this.onTap,
    this.subOptions,
    super.key,
  });

  @override
  State<ToolbarOption> createState() => _ToolbarOptionState();
}

class _ToolbarOptionState extends State<ToolbarOption> {
  Color hoverColor = Colors.transparent;
  Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap?.call();
      },
      onHover: _onHover,
      child: Container(
        color: color,
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 3,
        ),
        child: Text(widget.text),
      ),
    );
  }

  void _onHover(isHovered) {
    setState(() {
      color = isHovered ? hoverColor : null;
    });
  }
}
