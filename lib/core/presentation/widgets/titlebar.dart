import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class Titlebar extends StatelessWidget {
  const Titlebar({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      height: 35,
      child: Row(
        spacing: 8,
        children: [
          //
          // Logo + toolbar
          //
          SizedBox(width: 2),
          DragToMoveArea(
            child: Image.asset(
              'assets/icon/icon.png',
              width: 24,
              height: 24,
              filterQuality: FilterQuality.medium,
            ),
          ),

          if (child != null) child!,
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
