import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/presentation/widgets/help_widget.dart';
import '../../../settings_window/presentation/models/settings_route.dart';
import '../../../settings_window/presentation/pages/settings_window.dart';
import '../../../window_stack_manager/presentation/bloc/window_stack_manager_bloc.dart';

const breakPoints = [
  600,
  800,
  900,
  1000,
  1100,
];

class MyMenuBar extends StatelessWidget {
  const MyMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      child: Row(children: [
        if (screenWidth > breakPoints[0])
          ToolbarOption(
            'Bible',
            onTap: () {
              context.read<WindowStackManagerBloc>().add(
                    WindowStackManagerOpen(
                      SettingsWindow(
                          initialRoute: SettingsSection.bibleManager),
                    ),
                  );
            },
          ),
        if (screenWidth > breakPoints[1])
          ToolbarOption(
            'Settings',
            onTap: () {
              context.read<WindowStackManagerBloc>().add(
                    WindowStackManagerOpen(
                      SettingsWindow(
                        initialRoute: SettingsSection.appearance,
                      ),
                    ),
                  );
            },
          ),
        if (screenWidth > breakPoints[2])
          ToolbarOption(
            'Shortcuts',
            onTap: () {
              context.read<WindowStackManagerBloc>().add(
                    WindowStackManagerOpen(
                      SettingsWindow(
                        initialRoute: SettingsSection.shortcuts,
                      ),
                    ),
                  );
            },
          ),
        if (screenWidth > breakPoints[3])
          ToolbarOption(
            'Help',
            onTap: () {
              context
                  .read<WindowStackManagerBloc>()
                  .add(WindowStackManagerOpen(HelpWindow()));
            },
          ),
        if (screenWidth > breakPoints[4])
          ToolbarOption(
            'About',
            onTap: () {
              context.read<WindowStackManagerBloc>().add(
                    WindowStackManagerOpen(
                      SettingsWindow(
                        initialRoute: SettingsSection.about,
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
