import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../customizer/presentation/cubit/customizer_cubit.dart';

class VerseDivider extends StatelessWidget {
  const VerseDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final base = DefaultTextStyle.of(context).style.fontSize ?? 14;
    final effectiveFontSize = MediaQuery.of(context).textScaler.scale(base);

    final isEnabled =
        context.select((CustomizerCubit c) => c.state.theme.showVerseDivider);

    final verticalPadding = clampDouble(
      effectiveFontSize * (0.95 * effectiveFontSize * .01),
      12,
      128,
    );
    final spacerHeight = clampDouble(
      effectiveFontSize * (1 * effectiveFontSize * .01),
      12,
      128,
    );

    return isEnabled
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: verticalPadding),
            child: Divider(height: 1),
          )
        : SizedBox(height: spacerHeight);
  }
}
