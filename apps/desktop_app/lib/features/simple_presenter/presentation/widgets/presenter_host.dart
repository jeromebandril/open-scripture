import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/settings/settings_cubit.dart';
import '../../../text_scaler/presentation/widgets/text_scaler_host.dart';
import '../../domain/entities/slide_data.dart';
import '../../settings/presenter_settings.dart';
import '../cubit/presenter_cubit.dart';
import '../models/gradient_preset.dart';
import 'slide.dart';

class PresenterHost extends StatelessWidget {
  const PresenterHost({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.sl<SettingsCubit<PresenterSettings>>(),
      child: BlocSelector<PresenterCubit, PresenterState, PresenterStatus>(
        selector: (state) => state.status,
        builder: (context, status) {
          final settings =
              context.select((SettingsCubit<PresenterSettings> s) => s.state);

          // Make text slightly bigger when Prester is expanded
          final scale = status == PresenterStatus.expanded ? 1.25 : 1.0;

          return LayoutBuilder(builder: (context, constraints) {
            final maxHeight = constraints.maxHeight;
            final presenterHeght = maxHeight * settings.sizeFactor;

            return Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: switch (status) {
                    PresenterStatus.expanded => maxHeight,
                    PresenterStatus.showing => presenterHeght,
                    PresenterStatus.hidden => 0,
                    PresenterStatus.error => 0,
                  },
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: settings.useGradientBackground
                        ? GradientPreset.fromName(settings.gradientBackground)
                            ?.gradient
                        : null,
                    color: settings.backgroundColor,
                  ),
                  // This is for animating the text scaling
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 1.0, end: scale),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    builder: (context, statusScale, child) {
                      final mq = MediaQuery.of(context);

                      return MediaQuery(
                        data: mq.copyWith(
                          textScaler: TextScaler.linear(
                            mq.textScaler.scale(1.0) * statusScale,
                          ),
                        ),
                        child: child!,
                      );
                    },
                    child: TextScalerHost(
                      initialiSize: 40,
                      child: _Slider(),
                    ),
                  ),
                ),
                Expanded(child: RepaintBoundary(child: child)),
              ],
            );
          });
        },
      ),
    );
  }
}

class _Slider extends StatelessWidget {
  const _Slider();

  @override
  Widget build(BuildContext context) {
    final settings = context.select(
      (SettingsCubit<PresenterSettings> cubit) => cubit.state,
    );

    return BlocBuilder<PresenterCubit, PresenterState>(
      buildWhen: (previous, current) =>
          previous.slides != current.slides ||
          previous.currentSlideIndex != current.currentSlideIndex ||
          previous.status != current.status,
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: _buildSlide(
            state,
            enableAutoNumbering: settings.enableAutoNumbering,
            startNumberingFrom: settings.startNumberingFrom,
          ),
        );
      },
    );
  }

  Widget _buildSlide(
    PresenterState state, {
    required bool enableAutoNumbering,
    required int startNumberingFrom,
  }) {
    if (state.status == PresenterStatus.hidden || state.numberOfSlides == 0) {
      return const SizedBox.shrink(
        key: ValueKey('hidden'),
      );
    }

    final slide = state.getCurrentSlide()!;

    final title = enableAutoNumbering &&
            state.currentSlideIndex + 1 >= startNumberingFrom
        ? '${state.currentSlideIndex - startNumberingFrom + 2}. ${slide.title}'
        : slide.title;

    return Padding(
      key: ValueKey(slide.id),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Slide(
        data: SlideData(
          title: title,
          subtitle: slide.subtitle,
        ),
      ),
    );
  }
}
