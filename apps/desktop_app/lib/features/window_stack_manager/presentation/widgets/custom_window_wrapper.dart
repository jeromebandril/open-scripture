import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/design_system/design_system.dart';

import '../state/window_stack_manager_bloc.dart';

class CustomWindowWrapper extends StatelessWidget {
  const CustomWindowWrapper({
    super.key,
    required this.title,
    required this.child,
    required this.maxSize,
    this.elevation = 0,
    this.onClose,
  });

  final Function()? onClose;
  final String title;
  final Widget child;
  final Size maxSize;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.sm,
            children: [
              Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                      child: Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18))),
                  IconButton(
                      onPressed: () {
                        context
                            .read<WindowStackManagerBloc>()
                            .add(WindowStackManagerClose());
                        onClose?.call();
                      },
                      icon: const Icon(Icons.close)),
                ],
              ),
              Expanded(child: child),
            ],
          )),
    );
  }
}
