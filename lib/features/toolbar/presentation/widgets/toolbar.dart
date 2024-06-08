import 'package:flutter/material.dart';

/*
  TODO:
  - manage the appearing window widget lifecycle,
  I think I prefer to destroy it on close and recreate it
  every time (so it doesn't remain loaded in memory when
  not been used) 
*/

class Toolbar extends StatelessWidget {
  final Widget child;
  final List<ToolbarOption> options;

  const Toolbar({
    required this.child,
    required this.options,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _ToolbarApp(
      options: options,
      child: child,
    );
  }

  void showWindow(ctx, Widget content) {}
}

/// Usually a top widget, adds a desktop toolbar
/// on top of the application
class _ToolbarApp extends StatelessWidget {
  final Widget child;
  final List<ToolbarOption> options;

  const _ToolbarApp({
    required this.options,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 24,
          child: Row(children: options),
        ),
        Expanded(child: child),
      ],
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
  Color hoverColor = Colors.green;
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

  // void dispatch(ctx, String windowName) async {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: ctx,
  //     builder: (context) => Builder(
  //       builder: (context) {
  //         return BlocProvider.value(
  //           value: BlocProvider.of<AppScreenManagerBloc>(ctx)
  //             ..add(AppScreenManagerOpenWindow(windowName)),
  //           child: SettingsWindow(
  //             onClose: () => Navigator.pop(context, this),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
}
