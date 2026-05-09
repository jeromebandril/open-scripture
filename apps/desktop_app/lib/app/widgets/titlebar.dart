import 'package:flutter/material.dart';
import 'package:open_scripture/app/widgets/menubar.dart';
import 'package:open_scripture/shared/constants.dart';
import 'package:open_scripture/shared/theme/tokens.dart';
import 'package:window_manager/window_manager.dart';

class Titlebar extends StatelessWidget {
  const Titlebar({
    super.key,
    this.showButtons = true,
    this.showMenuBar = true,
    this.showLogo = true,
    this.centerItems,
    this.leftItems,
    this.rightItems,
  });

  final bool showButtons;
  final bool showMenuBar;
  final bool showLogo;
  final List<Widget>? leftItems;
  final List<Widget>? centerItems;
  final List<Widget>? rightItems;

  @override
  Widget build(BuildContext context) {
    // for gradient
    final surface = Theme.of(context).colorScheme.surface;
    final mid = Theme.of(context).colorScheme.surfaceContainerHighest;
    final width = MediaQuery.of(context).size.width;
    final band = 400 / width;
    final half = band / 2;

    return Container(
      height: kWindowsTitleBarHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [surface, mid, mid, surface],
          stops: [
            0.0,
            (0.5 - half).clamp(0.0, 1.0),
            (0.5 + half).clamp(0.0, 1.0),
            1.0,
          ],
        ),
      ),
      child: Stack(
        children: [
          //
          // Drag area
          //
          const Positioned.fill(
            child: DragToMoveArea(
              child: SizedBox(height: 38),
            ),
          ),
          //
          // CENTER widgets
          //
          if (centerItems != null)
            Positioned.fill(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: 3),
                child:
                    Row(mainAxisSize: MainAxisSize.min, children: centerItems!),
              ),
            ),
          //
          // LEFT and RIGHT widgets
          //
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //
                // Logo + Menubar
                //
                Row(
                  children: [
                    // if (showLogo) ...[
                    //   DragToMoveArea(
                    //     child: Container(
                    //       height: double.infinity,
                    //       width: 24 + 16, // icon width + spacing
                    //       alignment: Alignment.center,
                    //       color: Colors.transparent,
                    //       child: Image.asset(
                    //         'assets/icon/icon.png',
                    //         width: 24,
                    //         height: 24,
                    //         filterQuality: FilterQuality.medium,
                    //       ),
                    //     ),
                    //   ),
                    //   const SizedBox(width: 2),
                    // ],
                    if (showMenuBar) ...[
                      const SizedBox(width: AppSpacing.sm),
                      const MyMenuBar(),
                    ],
                    if (leftItems != null) ...[
                      const SizedBox(width: AppSpacing.xs),
                      Row(children: leftItems!),
                    ]
                  ],
                ),
                Row(
                  children: [
                    if (rightItems != null)
                      Row(
                        children: rightItems!,
                      ),
                    //
                    // Window buttons
                    //
                    if (showButtons) ...[
                      const SizedBox(width: AppSpacing.sm),
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
                    ]
                  ],
                ),
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
        backgroundColor: Colors.transparent,
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
