import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/shortcuts/domain/app_command.dart';
import 'package:open_scripture/features/shortcuts/presentation/models/app_command_shortcuts.dart';
import 'package:open_scripture/features/shortcuts/presentation/widget/shortcut_view.dart';

import '../bloc/b_searchbar_bloc.dart';

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
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isShortcutVisible = widget.focusNode != null &&
        !widget.focusNode!.hasFocus &&
        _controller.text.isEmpty;

    return SearchBar(
      controller: _controller,
      constraints:
          BoxConstraints(maxWidth: widget.width, minHeight: widget.height),
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
    );
  }
}

class _ErrorNotifier extends StatefulWidget {
  const _ErrorNotifier();

  @override
  State<_ErrorNotifier> createState() => _ErrorNotifierState();
}

class _ErrorNotifierState extends State<_ErrorNotifier> {
  final GlobalKey<TooltipState> _tooltipKey = GlobalKey<TooltipState>();
  Timer? _dismissTimer;

  void _scheduleShowAndAutoDismiss() {
    _dismissTimer?.cancel();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Show (only works if Tooltip is currently in the tree).
      _tooltipKey.currentState?.ensureTooltipVisible();

      // Force-dismiss after a while (deterministic).
      _dismissTimer = Timer(const Duration(seconds: 2), () {
        Tooltip.dismissAllToolTips();
      });
    });
  }

  void _dismissNow() {
    _dismissTimer?.cancel();
    Tooltip.dismissAllToolTips();
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BSearchbarBloc, BSearchbarState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status || prev.errorMessage != curr.errorMessage,
      listener: (BuildContext context, BSearchbarState state) {
        if (state.status == BSearchbarStatus.error) {
          _scheduleShowAndAutoDismiss();
        } else {
          _dismissNow();
        }
      },
      builder: (context, state) {
        if (state.status != BSearchbarStatus.error) return SizedBox.shrink();

        return Tooltip(
          key: _tooltipKey,
          //triggerMode: TooltipTriggerMode.manual,
          textStyle:
              TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(6),
          ),
          showDuration: const Duration(seconds: 1),
          message: state.errorMessage ?? 'error',
          child: const Icon(
            Icons.error_outline_rounded,
            size: 20,
            color: Color.fromARGB(200, 140, 140, 140),
          ),
        );
      },
    );
  }
}
