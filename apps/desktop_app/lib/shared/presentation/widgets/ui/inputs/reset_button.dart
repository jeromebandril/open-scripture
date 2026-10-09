import 'package:flutter/material.dart';

class ResetButton extends StatelessWidget {
  const ResetButton({super.key, this.onPress});

  final Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onPress,
        icon: const Icon(
          Icons.restart_alt_outlined,
        ));
  }
}
