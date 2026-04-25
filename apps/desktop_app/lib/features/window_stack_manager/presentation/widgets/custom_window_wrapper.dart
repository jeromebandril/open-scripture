import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/shared/theme/tokens.dart';

import '../state/window_stack_manager_bloc.dart';

class CustomWindowWrapper extends StatelessWidget {
  const CustomWindowWrapper({
    super.key,
    required this.title,
    required this.child,
    required this.size,
    this.elevation = 0,
    this.onClose,
  });

  final Function()? onClose;
  final String title;
  final Widget child;
  final Size size;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      child: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  SizedBox(width: 16),
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
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(16),
                child: child,
              )),
            ],
          )),
    );
  }
}
