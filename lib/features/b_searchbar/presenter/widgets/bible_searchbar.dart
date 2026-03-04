import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/bible_display/bible_pane/presentation/bloc/bible_pane_bloc.dart';
import 'package:open_scripture/features/bible_display/split_screen/presenter/cubit/pane_manager_cubit.dart';

import '../../../bible_display/bible_pane/presentation/models/display_mode.dart';
import '../bloc/b_searchbar_bloc.dart';
import '../models/find_intent.dart';

class BSearchbar extends StatefulWidget {
  const BSearchbar({
    this.focusNode,
    this.onSubmitted,
    this.onEditComplete,
    this.height = 42,
    this.isDense = false,
    super.key,
  });

  final FocusNode? focusNode;
  final Function()? onSubmitted;
  final Function()? onEditComplete;
  final double height;
  final bool isDense;

  @override
  State<BSearchbar> createState() => _BSearchbarState();
}

class _BSearchbarState extends State<BSearchbar> {
  bool _findMode = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode?.addListener(() {
      if (widget.focusNode?.hasFocus == null || !widget.focusNode!.hasFocus) {
        _findMode = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: widget.height,
      child: Stack(
        children: [
          //
          // Searchbar
          //
          Positioned.fill(
            child: Shortcuts(
              shortcuts: {
                const DollarActivator(): const FindIntent(),
              },
              child: Actions(
                actions: {
                  FindIntent: CallbackAction<FindIntent>(
                    onInvoke: (intent) {
                      setState(() => _findMode = true);
                      return;
                    },
                  ),
                },
                child: TextField(
                  focusNode: widget.focusNode,
                  selectAllOnFocus: true,
                  onChanged: (key) {},
                  onEditingComplete: () {
                    if (widget.onEditComplete != null) {
                      widget.onEditComplete!();
                    }
                  },
                  onSubmitted: (input) {
                    if (widget.onSubmitted != null) widget.onSubmitted!();

                    if (_findMode) {
                      final bibleIds = context
                          .read<PaneManagerCubit>()
                          .activePane()
                          .bloc
                          .state
                          .openedBiblesIds;

                      if (bibleIds.isEmpty) return;

                      // only list view
                      context
                          .read<PaneManagerCubit>()
                          .activePane()
                          .bloc
                          .add(BiblePaneSetDisplayMode(DisplayMode.normal));
                      context.read<BSearchbarBloc>().add(BSearchbarFind(
                            bibleIds: bibleIds,
                            query: input,
                          ));

                      return;
                    }

                    BlocProvider.of<BSearchbarBloc>(context)
                        .add(BSearchbarParseIntent(input));
                  },
                  decoration: InputDecoration(
                    isDense: widget.isDense,
                    prefixText: !_findMode ? null : '   find:   ',
                    prefixIcon: !_findMode
                        ? Icon(
                            Icons.search,
                            size: 18,
                            color: Theme.of(context).colorScheme.onSurface,
                          )
                        : null,
                    contentPadding: const EdgeInsets.only(right: 36),
                    hintText: !_findMode ? 'Search reference' : null,
                    filled: true,
                    fillColor:
                        Theme.of(context).colorScheme.surfaceContainerHigh,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    hoverColor: Colors.transparent,
                    // focusedBorder: const OutlineInputBorder(
                    //   borderSide: BorderSide(color: Colors.transparent),
                    // ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                ),
              ),
            ),
          ),
          //
          // Error notifier
          //
          Positioned.fill(
            right: 10,
            child: Container(
              alignment: AlignmentDirectional.centerEnd,
              child: _ErrorNotifier(),
            ),
          ),
        ],
      ),
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
