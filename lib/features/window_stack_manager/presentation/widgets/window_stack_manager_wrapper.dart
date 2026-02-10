import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/obs_live_overlay/presentation/cubit/obs_live_overlay_cubit.dart';
import 'package:open_scripture/features/window_stack_manager/presentation/bloc/window_stack_manager_bloc.dart';

// dev notes: old version was to keep a map of id -> Widget, but I opted
// to build and destroy the window every time it opens/closes, so I can
// save memory, because these Widgets will not be used very often by the user

class WindowStackManagerWrapper extends StatefulWidget {
  final Widget child;

  const WindowStackManagerWrapper({
    required this.child,
    super.key,
  });

  @override
  State<WindowStackManagerWrapper> createState() =>
      _WindowStackManagerWrapperState();
}

class _WindowStackManagerWrapperState extends State<WindowStackManagerWrapper> {
  OverlayEntry? _entry;
  late final FocusScopeNode _windowFocusScope;

  @override
  void initState() {
    _windowFocusScope = FocusScopeNode(debugLabel: 'window');
    super.initState();
  }

  @override
  void dispose() {
    _removeEntry();
    _windowFocusScope.dispose();
    super.dispose();
  }

  void _removeEntry() {
    _entry?.remove();
    _entry = null;
  }

  void _showEntry(WidgetBuilder builder) {
    if (_entry != null) return;

    _entry = OverlayEntry(
      builder: (overlayContext) {
        return BlocProvider.value(
          value: context.read<ObsLiveOverlayCubit>(),
          child: Stack(
            children: [
              const ModalBarrier(dismissible: false, color: Color(0x99000000)),
              BlockSemantics(
                blocking: true,
                child: FocusScope(
                  node: _windowFocusScope,
                  child: Center(
                    child: Material(
                      type: MaterialType.transparency,
                      elevation: 24,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                          margin: EdgeInsets.all(24),
                          child: builder(overlayContext)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    Overlay.of(context, rootOverlay: true).insert(_entry!);

    // ensure focus is moved after insertion
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _windowFocusScope.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WindowStackManagerBloc, WindowStackManagerState>(
      listener: (_, state) {
        final builder = state.window;
        if (builder != null) {
          _showEntry(builder);
        } else {
          _removeEntry();
        }
      },
      child: widget.child,
    );
  }
}
