import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../shared/design_system/tokens/spacing.dart';
import '../../../../shared/presentation/widgets/service_status_indicator_shell.dart';
import '../cubit/presenter_cubit.dart';

class PresenterIndicator extends StatelessWidget {
  const PresenterIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<PresenterCubit, PresenterState>(
      builder: (context, state) {
        if (state.numberOfSlides == 0 ||
            state.getCurrentSlide()?.title == null) {
          return const SizedBox.shrink();
        }

        return ServiceStatusIndicatorShell(
          label: Text(
            state.getCurrentSlide()!.title,
            style: textTheme.bodySmall,
          ),
          icon: LucideIcons.rectangleCircle,
          onIconPressed: () {},
        );
      },
    );
  }
}
