import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
          label: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 120),
            child: Text(
              state.getCurrentSlide()!.title,
              style: textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          icon: LucideIcons.rectangleCircle,
          onIconPressed: () {},
        );
      },
    );
  }
}
