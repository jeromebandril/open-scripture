import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../text_scaler/presentation/widgets/text_scaler_host.dart';
import '../../domain/entities/slide_data.dart';
import '../cubit/presenter_cubit.dart';
import 'slide.dart';

class PresenterHost extends StatelessWidget {
  const PresenterHost({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height;
    final presenterHeght = maxHeight * 0.40;

    return BlocSelector<PresenterCubit, PresenterState, bool>(
      selector: (state) => state.isShowing,
      builder: (context, isShowing) {
        return Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: isShowing ? presenterHeght : 0,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-0.8, -0.9),
                  radius: 1.4,
                  colors: [
                    Color(0xFF38BDF8),
                    Color(0xFF2563EB),
                    Color(0xFF1E3A8A),
                    Color(0xFF0F172A),
                  ],
                  stops: [0.0, 0.35, 0.7, 1.0],
                ),
              ),
              child: TextScalerHost(
                // arbitrary value because it is useless in this case
                // because all texts have already their own initial size
                initialiSize: 40,
                child: _Slider(),
              ),
            ),
            Expanded(child: RepaintBoundary(child: child)),
          ],
        );
      },
    );
  }
}

class _Slider extends StatelessWidget {
  const _Slider();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PresenterCubit, PresenterState>(
      buildWhen: (prev, curr) =>
          prev.slides != curr.slides ||
          prev.currentSlideIndex != curr.currentSlideIndex ||
          prev.isShowing != curr.isShowing,
      builder: (context, state) {
        final hasSlide = state.numberOfSlides > 0;

        final Widget child;

        if (!state.isShowing || !hasSlide) {
          child = const SizedBox.shrink(
            key: ValueKey('hidden'),
          );
        } else {
          final slide = state.getCurrentSlide()!;

          child = Padding(
            key: ValueKey(slide.id),
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Slide(
              data: SlideData(
                title: slide.title,
                subtitle: slide.subtitle,
              ),
            ),
          );
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: child,
        );
      },
    );
  }
}
