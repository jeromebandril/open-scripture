import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/state/fullscreen_cubit.dart';
import '../../../../../app/state/interface_visibility_cubit.dart';
import '../../../../shortcuts/domain/models/app_command.dart';
import '../../../../shortcuts/presentation/models/app_command_shortcuts.dart';
import '../../../../shortcuts/presentation/widgets/shortcut_view.dart';
import '../../../../shortcuts/presentation/widgets/shortcuts_focus_scope.dart';
import '../state/search_bloc.dart';

class BSearchbar extends StatelessWidget {
  const BSearchbar({
    this.onSubmitted,
    this.height = 42,
    this.width = 280,
    this.isDense = false,
    super.key,
  });

  final Function()? onSubmitted;
  final double height;
  final double width;
  final bool isDense;

  @override
  Widget build(BuildContext context) {
    final focusNode = ShortcutFocusScope.of(context).search;

    return BlocConsumer<SearchBloc, SearchState>(
      listenWhen: (prev, curr) =>
          prev.errorCount != curr.errorCount && curr.errorCount > 0,
      listener: (context, state) {
        if (state is! SearchError) return;
        final isFullscreen = context.read<FullscreenCubit>().state;
        final showMenuBar =
            context.read<InterfaceVisibilityCubit>().state.isToolbarVisible;
        if (!isFullscreen || showMenuBar) return;
      },
      buildWhen: (prev, curr) =>
          prev.errorCount != curr.errorCount && curr.errorCount > 0,
      builder: (context, state) {
        return _SearchBarWithErrorFeedback(
          hasError: state is SearchError,
          errorTrigger: state.errorCount,
          child: SearchBar(
            constraints: BoxConstraints(maxWidth: width, minHeight: height),
            focusNode: focusNode,
            leading: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Icon(
                Icons.search,
                size: 18,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            hintText: 'Search reference',
            elevation: const WidgetStatePropertyAll(0),
            trailing: [
              ListenableBuilder(
                listenable: focusNode,
                builder: (context, __) {
                  if (focusNode.hasFocus) return SizedBox.shrink();
                  return Container(
                    alignment: AlignmentDirectional.centerEnd,
                    child: ShortcutView(
                      activator: appCommandShortcuts[AppCommand.focusSearch],
                      textColor: Theme.of(context).colorScheme.onSurfaceVariant,
                      fillColor: Colors.transparent,
                      borderColor: null,
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ],
            onSubmitted: (input) {
              if (onSubmitted != null) onSubmitted!();
              if (input.isEmpty) return;

              // if (_findMode) {
              //   final bibleIds = context
              //       .read<PaneManagerCubit>()
              //       .activePane()
              //       .bloc
              //       .state
              //       .openedBiblesIds;

              //   if (bibleIds.isEmpty) return;

              //   // only list view
              //   context
              //       .read<PaneManagerCubit>()
              //       .activePane()
              //       .bloc
              //       .add(BiblePaneSetDisplayMode(DisplayMode.normal));
              //   context.read<BSearchbarBloc>().add(BSearchbarFind(
              //         bibleIds: bibleIds,
              //         query: input,
              //       ));

              //   return;
              // }

              BlocProvider.of<SearchBloc>(context)
                  .add(SearchParseIntent(input));
            },
          ),
        );
      },
    );
  }
}

class _SearchBarWithErrorFeedback extends StatefulWidget {
  const _SearchBarWithErrorFeedback({
    required this.child,
    required this.errorTrigger,
    required this.hasError,
  });

  final Widget child;
  final int errorTrigger; // increments on each new error
  final bool hasError;

  @override
  State<_SearchBarWithErrorFeedback> createState() =>
      _SearchBarWithErrorFeedbackState();
}

class _SearchBarWithErrorFeedbackState
    extends State<_SearchBarWithErrorFeedback>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _progress = TweenSequence<double>([
      // Beep 1 — fade in
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 13,
      ),
      // Beep 1 — hold
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 15),
      // Beep 1 — fade out
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 13,
      ),
      // Gap between beeps
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 11),
      // Beep 2 — fade in
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 13,
      ),
      // Beep 2 — hold
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 15),
      // Beep 2 — fade out (longer tail)
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(_SearchBarWithErrorFeedback oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.errorTrigger != oldWidget.errorTrigger &&
        widget.errorTrigger > 0) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;
    final borderRadius =
        BorderRadius.circular(50); // match SearchBar's pill shape

    return AnimatedBuilder(
      animation: _progress,
      builder: (context, child) {
        return CustomPaint(
          foregroundPainter: _progress.value <= 1.0
              ? _BorderProgressPainter(
                  progress: _progress.value,
                  color: errorColor,
                  borderRadius: borderRadius,
                  strokeWidth: 2.0,
                )
              : null,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _BorderProgressPainter extends CustomPainter {
  const _BorderProgressPainter({
    required this.progress,
    required this.color,
    required this.borderRadius,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final BorderRadius borderRadius;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rrect = RRect.fromRectAndCorners(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    );

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(_BorderProgressPainter old) =>
      old.progress != progress || old.color != color;
}
