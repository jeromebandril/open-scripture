import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_smyrna_bible_v2/features/window_stack_manager/presentation/bloc/window_stack_manager_bloc.dart';

// dev notes: old version was to keep a map of id -> Widget, but I opted
// to build and destroy the window every time it opens/closes, so I can
// save memory, because these Widgets will not be used very often by the user

class WindowStackManagerWrapper extends StatelessWidget {
  final Widget child;

  const WindowStackManagerWrapper({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<WindowStackManagerBloc, WindowStackManagerState>(
      listener: (dContext, state) {
        if (state.window != null) {
          showDialog(
            barrierDismissible: false,
            context: dContext,
            builder: (_) => state.window!,
          );
        } else {
          Navigator.of(dContext).pop();
        }
      },
      child: child,
    );
  }
}
