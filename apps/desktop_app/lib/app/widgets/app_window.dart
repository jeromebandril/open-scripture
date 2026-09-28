import 'package:flutter/material.dart';

import '../../shared/design_system/design_system.dart';

class AppWindow extends StatelessWidget {
  const AppWindow({
    super.key,
    required this.title,
    required this.child,
    this.minSize = Size.zero,
    this.maxSize = const Size(double.infinity, double.infinity),
  });

  final String title;
  final Widget child;
  final Size minSize;
  final Size maxSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: minSize.width,
            minHeight: minSize.height,
            maxWidth: maxSize.width,
            maxHeight: maxSize.height,
          ),
          child: Container(
            padding: const EdgeInsets.only(
              left: AppSpacing.md,
              right: AppSpacing.md,
              top: AppSpacing.md,
              bottom: AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacing.md,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                Flexible(
                  child: child,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
