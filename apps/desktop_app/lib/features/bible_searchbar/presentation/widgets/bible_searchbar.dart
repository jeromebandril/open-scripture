import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/shortcuts/domain/models/app_command.dart';
import 'package:open_scripture/features/shortcuts/presentation/models/app_command_shortcuts.dart';
import 'package:open_scripture/features/shortcuts/presentation/widgets/shortcut_view.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/app_state/fullscreen_cubit.dart';
import '../../../../core/app_state/menubar_visibility_cubit.dart';
import '../state/b_searchbar_bloc.dart';

class BSearchbar extends StatefulWidget {
  const BSearchbar({
    this.focusNode,
    this.onSubmitted,
    this.height = 42,
    this.width = 280,
    this.isDense = false,
    super.key,
  });

  final FocusNode? focusNode;
  final Function()? onSubmitted;
  final double height;
  final double width;
  final bool isDense;

  @override
  State<BSearchbar> createState() => _BSearchbarState();
}

class _BSearchbarState extends State<BSearchbar> {
  @override
  Widget build(BuildContext context) {
    final isShortcutVisible =
        widget.focusNode != null && !widget.focusNode!.hasFocus;

    return BlocConsumer<BSearchbarBloc, BSearchbarState>(
      listenWhen: (prev, curr) =>
          prev.errorCount != curr.errorCount && curr.errorCount > 0,
      listener: (context, state) {
        if (state is! SearchError) return;
        final isFullscreen = context.read<FullscreenCubit>().state;
        final showMenuBar = context.read<MenubarCubit>().state;
        if (!isFullscreen || showMenuBar) return;

        toastification.show(
            context: context,
            type: ToastificationType.error,
            style: ToastificationStyle.flat,
            title: Text("Invalid query"),
            description: Text(state.message),
            alignment: Alignment.topRight,
            autoCloseDuration: const Duration(seconds: 4),
            animationBuilder: (context, animation, alignment, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            animationDuration: const Duration(milliseconds: 300),
            backgroundColor:
                Theme.of(context).colorScheme.surfaceContainerHighest,
            foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
            boxShadow: highModeShadow,
            closeButton:
                const ToastCloseButton(showType: CloseButtonShowType.onHover),
            showProgressBar: true,
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.surfaceContainerLow));
      },
      buildWhen: (prev, curr) =>
          prev.errorCount != curr.errorCount && curr.errorCount > 0,
      builder: (context, state) {
        return _SearchBarWithErrorFeedback(
          hasError: state is SearchError,
          errorTrigger: state.errorCount,
          child: SearchBar(
            constraints: BoxConstraints(
                maxWidth: widget.width, minHeight: widget.height),
            focusNode: widget.focusNode,
            leading: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Icon(
                Icons.search,
                size: 18,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            hintText: 'Search reference',
            elevation: const WidgetStatePropertyAll(0),
            trailing: [
              if (isShortcutVisible)
                Container(
                  alignment: AlignmentDirectional.centerEnd,
                  child: ShortcutView(
                    activator: appCommandShortcuts[AppCommand.focusSearch],
                    textColor: Theme.of(context).colorScheme.onSurfaceVariant,
                    fillColor: Colors.transparent,
                    borderColor: null,
                    fontSize: 10,
                  ),
                ),
            ],
            onSubmitted: (input) {
              if (widget.onSubmitted != null) widget.onSubmitted!();
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

              BlocProvider.of<BSearchbarBloc>(context)
                  .add(BSearchbarParseIntent(input));
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
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _progress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  void didUpdateWidget(_SearchBarWithErrorFeedback oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.errorTrigger != oldWidget.errorTrigger &&
        widget.errorTrigger > 0) {
      _controller
          .forward(from: 0.0)
          .then((_) => _controller.reverse())
          .then((_) => _controller.forward())
          .then((_) => _controller.reverse());
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
          foregroundPainter: _progress.value < 1.0
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
      ..color = color.withOpacity(progress)
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
