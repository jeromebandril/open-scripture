import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/bible_installer_manager/presentation/bloc/installed_bibles/installed_bibles_bloc.dart';
import 'package:open_scripture/features/obs_live_overlay/presentation/cubit/obs_overlay/obs_live_overlay_cubit.dart';
import 'package:open_scripture/features/window_stack_manager/presentation/bloc/window_stack_manager_bloc.dart';

import '../../../obs_live_overlay/presentation/cubit/cubit/obs_live_overlay_settings_cubit.dart';

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
  final List<OverlayEntry> _entries = [];
  OverlayEntry? _barrierEntry;
  final List<FocusScopeNode> _focusNodes = [];

  @override
  void dispose() {
    _removeAll();
    super.dispose();
  }

  void _removeAll() {
    _barrierEntry?.remove();
    _barrierEntry = null;

    for (final e in _entries) {
      e.remove();
    }
    _entries.clear();

    for (final n in _focusNodes) {
      n.dispose();
    }
    _focusNodes.clear();
  }

  OverlayEntry _buildEntry({
    required WidgetBuilder builder,
    required FocusScopeNode focusNode,
  }) {
    return OverlayEntry(
      builder: (overlayContext) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<WindowStackManagerBloc>()),
            BlocProvider.value(value: context.read<ObsLiveOverlayCubit>()),
            BlocProvider.value(
                value: context.read<ObsLiveOverlaySettingsCubit>()),
            BlocProvider.value(value: context.read<InstalledBiblesBloc>()),
          ],
          child: BlockSemantics(
            blocking: true,
            child: FocusScope(
              node: focusNode,
              child: Center(
                child: Material(
                  type: MaterialType.transparency,
                  elevation: 24,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    margin: const EdgeInsets.all(24),
                    child: builder(overlayContext),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _syncToWindows(List<WidgetBuilder> windows) {
    final overlay = Overlay.of(context, rootOverlay: true);

    // ensure barrier
    _barrierEntry ??= OverlayEntry(
      builder: (_) => ModalBarrier(
        dismissible: false,
        color: Color(0x99000000),
      ),
    );

    if (windows.isEmpty) {
      _removeAll();
      return;
    }

    // POP
    while (_entries.length > windows.length) {
      final lastEntry = _entries.removeLast();
      lastEntry.remove();

      final lastFocus = _focusNodes.removeLast();
      lastFocus.dispose();
    }

    // PUSH
    while (_entries.length < windows.length) {
      final focusNode = FocusScopeNode(debugLabel: 'window_${_entries.length}');
      _focusNodes.add(focusNode);

      final entry = _buildEntry(
        builder: windows[_entries.length],
        focusNode: focusNode,
      );
      _entries.add(entry);
      overlay.insert(entry); // inserted after previous -> on top
    }

    // Place barrier below the last entry
    final top = _entries.last;
    top.remove();
    if (_barrierEntry!.mounted) _barrierEntry!.remove();
    overlay.insert(_barrierEntry!);
    overlay.insert(top);

    // Focus top-most
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes.last.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WindowStackManagerBloc, WindowStackManagerState>(
      listener: (_, state) {
        _syncToWindows(state.windows);
      },
      child: widget.child,
    );
  }
}
