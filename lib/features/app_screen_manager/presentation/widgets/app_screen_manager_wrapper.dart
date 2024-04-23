import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_smyrna_bible_v2/features/app_screen_manager/presentation/bloc/app_screen_manager_bloc.dart';
import '../../../../injection_container.dart';

/*
  TODO:
  - manage the appearing window widget lifecycle,
  I think I prefer to destroy it on close and recreate it
  every time (so it doesn't remain loaded in memory when
  not been used) 
*/

class AppScreenManagerWrapper extends StatelessWidget {
  final Widget child;
  final Map<String, Widget>? windows;
  final List<ToolbarOption> options;

  const AppScreenManagerWrapper({
    required this.child,
    required this.options,
    this.windows,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AppScreenManagerBloc>(),
      child: _ToolbarApp(
        options: options,
        child: Stack(
          children: [
            child,
            BlocBuilder<AppScreenManagerBloc, AppScreenManagerState>(
              builder: (ctx, state) {
                return state.currentOpenWindow == null ||
                        windows?[state.currentOpenWindow] == null
                    ? const SizedBox()
                    : Positioned.fill(
                        child: windows![state.currentOpenWindow]!,
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
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
  final Function()? onTap;
  final String? opens;
  final List<ToolbarOption>? subOptions;

  const ToolbarOption({
    required this.text,
    this.onTap,
    this.opens,
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
        if (widget.opens != null) {
          dispatch(context, widget.opens!);
        }
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

  void dispatch(ctx, String windowName) {
    if (BlocProvider.of<AppScreenManagerBloc>(ctx).state.status ==
        AppScreenManagerStatus.open) {
      BlocProvider.of<AppScreenManagerBloc>(ctx)
          .add(AppScreenManagerCloseWindow());
    } else {
      BlocProvider.of<AppScreenManagerBloc>(ctx)
          .add(AppScreenManagerOpenWindow(windowName));
    }
  }
}
