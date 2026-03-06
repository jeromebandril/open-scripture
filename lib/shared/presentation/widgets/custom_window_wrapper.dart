import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/window_stack_manager/presentation/bloc/window_stack_manager_bloc.dart';

class CustomWindowWrapper extends StatelessWidget {
  const CustomWindowWrapper({
    super.key,
    required this.title,
    required this.child,
    this.onClose,
  });

  final Function()? onClose;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 450,
        height: 315,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
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
            Expanded(child: child),
          ],
        ));
  }
}
