import 'package:flutter/material.dart';
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
      height: 38,
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              spacing: 8,
              children: [
                //
                // Logo + toolbar
                //
                if (showLogo || showMenuBar) SizedBox(width: 2),
                if (showLogo)
                  DragToMoveArea(
                    child: Image.asset(
                      'assets/icon/icon.png',
                      width: 24,
                      height: 24,
                      filterQuality: FilterQuality.medium,
                    ),
                  ),
                if (menuBar != null && showMenuBar || toolbar == null) menuBar!,
                //
                // Space in between and draggable
                //
                Expanded(
                  child: DragToMoveArea(
                    child: Container(
                      height: 40,
                      color: Colors.transparent,
                    ),
                  ),
                ),
                //
                // Window buttons
                //
                if (showButtons)
                  _WindowButton(
                    icon: Icons.minimize_rounded,
                    onPressed: () => windowManager.minimize(),
                  ),
                if (showButtons)
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
                if (showButtons)
                  _WindowButton(
                    icon: Icons.close_rounded,
                    hoverColor: const Color.fromARGB(255, 228, 68, 56),
                    onPressed: () => windowManager.close(),
                  ),
              ],
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
        fixedSize: const Size(40, 40),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // square
        ),
        hoverColor: hoverColor ?? Colors.grey.shade400,
      ),
      icon: Icon(icon, size: 16),
      onPressed: onPressed,
    );
  }
}
