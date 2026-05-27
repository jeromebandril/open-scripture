import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/bible_installer_manager/presentation/state/installer/installer_bloc.dart';
import 'package:open_scripture/features/obs_live_overlay/presentation/state/obs_overlay/obs_live_overlay_cubit.dart';
import 'package:open_scripture/features/remote_controller/presentation/state/remote_controller/remote_controller_cubit.dart';
import 'package:open_scripture/features/shortcuts/presentation/widgets/shortcuts_scope_suppressed.dart';
import 'package:open_scripture/features/window_stack_manager/presentation/state/window_stack_manager_bloc.dart';
import 'package:open_scripture/shared/constants.dart';
import 'package:open_scripture/app/widgets/titlebar.dart';
import 'package:open_scripture/shared/theme/tokens.dart';

import '../../../../app/state/fullscreen_cubit.dart';
import '../../../obs_live_overlay/presentation/state/obs_overlay_settinsg/obs_live_overlay_settings_cubit.dart';
import '../../../remote_controller/presentation/state/remote_controller_settings/remote_controller_settings_cubit.dart';

class WindowStackManagerHost extends StatefulWidget {
  final Widget child;

  const WindowStackManagerHost({
    required this.child,
    super.key,
  });

  @override
  State<WindowStackManagerHost> createState() => _WindowStackManagerHostState();
}

class _WindowStackManagerHostState extends State<WindowStackManagerHost> {
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

    // manage last focus node before dispoing all of them
    final lastFocus = _focusNodes.removeLast();
    if (lastFocus.hasFocus) FocusManager.instance.primaryFocus?.unfocus();
    lastFocus.dispose();

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
        return ShortcutsScopeSuppressed(
          child: Positioned(
            top: kWindowsTitleBarHeight,
            bottom: 0,
            right: 0,
            left: 0,

            ///
            /// Damn I really need to re-pass the cubits here
            ///
            child: MultiBlocProvider(
              providers: [
                if (!kIsWeb) ...[
                  BlocProvider.value(
                      value: context.read<ObsLiveOverlaySettingsCubit>()),
                  BlocProvider.value(
                      value: context.read<ObsLiveOverlayCubit>()),
                  BlocProvider.value(value: context.read<InstallerBloc>()),
                  BlocProvider.value(
                      value: context.read<RemoteControllerCubit>()),
                  BlocProvider.value(
                      value: context.read<RemoteControllerSettingsCubit>()),
                ],
                BlocProvider.value(
                    value: context.read<WindowStackManagerBloc>()),
              ],
              child: BlockSemantics(
                blocking: true,
                child: FocusScope(
                  node: focusNode,
                  child: Center(
                    child: Material(
                      type: MaterialType.transparency,
                      elevation: 24,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      child: Container(
                        margin: const EdgeInsets.all(24),
                        child: builder(overlayContext),
                      ),
                    ),
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
    final isFullscreen = context.read<FullscreenCubit>().state;

    // ensure barrier
    _barrierEntry ??= OverlayEntry(
      builder: (_) => Column(
        children: [
          if (!isFullscreen && !kIsWeb)
            const Material(child: Titlebar(showMenuBar: false)),
          const Expanded(
            child: ModalBarrier(
              dismissible: false,
              color: Color(0x99000000),
            ),
          ),
        ],
      ),
    );

    if (windows.isEmpty) {
      _removeAll();
      return;
    }

    // POP
    while (_entries.length > windows.length) {
      final lastEntry = _entries.removeLast();
      final lastFocus = _focusNodes.removeLast();

      if (lastFocus.hasFocus) {
        FocusManager.instance.primaryFocus?.unfocus();
      }

      lastEntry.remove();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        lastFocus.dispose();
      });
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
