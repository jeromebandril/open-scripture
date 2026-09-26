import 'package:flutter/material.dart';

import '../../shared/design_system/design_system.dart';

class AppWindow extends StatelessWidget {
  const AppWindow({
    super.key,
    required this.title,
    required this.child,
    required this.maxSize,
  });

  final String title;
  final Widget child;
  final Size maxSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: AppSpacing.lg,
      ),
      constraints: BoxConstraints(
        maxWidth: maxSize.width,
        maxHeight: maxSize.height,
      ),
      child: Column(
        spacing: AppSpacing.md,
        children: [
          Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
