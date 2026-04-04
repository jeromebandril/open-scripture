import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/shared/constants/constants.dart';
import 'package:open_scripture/shared/presentation/cubit/toolbar_cubit.dart';
import 'package:window_manager/window_manager.dart';

class Titlebar extends StatelessWidget {
  const Titlebar({
    super.key,
    this.showButtons = true,
    this.showMenuBar = true,
    this.showLogo = true,
    this.toolbar,
    this.menuBar,
  });

  final bool showButtons;
  final bool showMenuBar;
  final bool showLogo;
  final Widget? menuBar;
  final Widget? toolbar;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      height: kWindowsTitleBarHeight,
      child: Stack(
        children: [
          Positioned.fill(
            child: DragToMoveArea(
              child: SizedBox(height: 38),
            ),
          ),
          if (toolbar != null)
            Positioned.fill(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: 3),
                child: toolbar!,
              ),
            ),
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //
                // Logo + Menubar
                //
                Row(
                  children: [
                    if (showLogo)
                      DragToMoveArea(
                        child: Container(
                          height: double.infinity,
                          width: 24 + 16, // icon width + spacing
                          alignment: Alignment.center,
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          child: Image.asset(
                            'assets/icon/icon.png',
                            width: 24,
                            height: 24,
                            filterQuality: FilterQuality.medium,
                          ),
                        ),
                      ),
                    if (!showLogo && showMenuBar) SizedBox(width: 8),
                    if (menuBar != null && showMenuBar) ...[
                      menuBar!,
                      BlocSelector<ToolbarCubit, ToolbarState, bool>(
                        selector: (state) => state.isVisible,
                        builder: (context, isVisible) {
                          return IconButton(
                            tooltip: '${isVisible ? 'Hide' : 'Show'} Toolbar',
                            onPressed: () =>
                                context.read<ToolbarCubit>().toggleVisibility(),
                            icon: isVisible
                                ? const Icon(Icons.expand_less_rounded,
                                    size: 18)
                                : const Icon(Icons.expand_more_rounded,
                                    size: 18),
                          );
                        },
                      )
                    ]
                  ],
                ),
                //
                // Window buttons
                //
                if (showButtons)
                  Row(
                    children: [
                      _WindowButton(
                        icon: Icons.minimize_rounded,
                        onPressed: () => windowManager.minimize(),
                      ),
                      _WindowButton(
                        icon: Icons.crop_square_rounded,
                        onPressed: () async {
                          if (await windowManager.isMaximized()) {
                            windowManager.restore();
                          } else {
                            windowManager.maximize();
                          }
                        },
                      ),
                      _WindowButton(
                        icon: Icons.close_rounded,
                        hoverColor: const Color.fromARGB(255, 228, 68, 56),
                        onPressed: () => windowManager.close(),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WindowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? hoverColor;

  const _WindowButton({
    required this.icon,
    required this.onPressed,
    this.hoverColor,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: 16,
      style: IconButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        //fixedSize: const Size(40, 40),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // square
        ),
        hoverColor: hoverColor ?? Colors.black26,
      ),
      icon: Icon(icon, size: 16),
      onPressed: onPressed,
    );
  }
}
