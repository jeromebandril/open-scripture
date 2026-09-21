import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/slide_data.dart';
import '../cubit/presenter_cubit.dart';
import 'slide.dart';

class PresenterHost extends StatelessWidget {
  const PresenterHost({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height;
    final presenterHeght = maxHeight * 0.45;

    return BlocSelector<PresenterCubit, PresenterState, bool>(
      selector: (state) => state.isShowing,
      builder: (context, isShowing) {
        return Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              height: isShowing ? presenterHeght : 0,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-0.8, -0.9),
                  radius: 1.4,
                  colors: [
                    Color(0xFF38BDF8), // cyan glow
                    Color(0xFF2563EB), // blue
                    Color(0xFF1E3A8A), // deep blue
                    Color(0xFF0F172A), // dark navy
                  ],
                  stops: [0.0, 0.35, 0.7, 1.0],
                ),
              ),
              child: _Slider(),
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
        late final SlideData slide;
        if (hasSlide) slide = state.getCurrentSlide()!;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: !state.isShowing || !hasSlide
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Slide(
                    key: ValueKey(slide.id),
                    data: SlideData(
                      title: slide.title,
                      subtitle: slide.subtitle,
                    ),
                  ),
                ),
        );
      },
    );
  }
}
