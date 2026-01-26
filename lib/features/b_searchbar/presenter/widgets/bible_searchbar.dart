import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/b_searchbar_bloc.dart';

class BSearchbar extends StatelessWidget {
  const BSearchbar({
    this.focusNode,
    this.onSubmitted,
    this.onEditComplete,
    super.key,
  });

  final FocusNode? focusNode;
  final Function()? onSubmitted;
  final Function()? onEditComplete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: 400,
        height: 48,
        child: Stack(
          children: [
            //
            // Searchbar
            //
            Positioned.fill(
              right: 28,
              child: TextField(
                focusNode: focusNode,
                onEditingComplete: () {
                  if (onEditComplete != null) onEditComplete!();
                },
                onSubmitted: (input) {
                  BlocProvider.of<BSearchbarBloc>(context)
                      .add(BSearchbarParseIntent(input));

                  if (onSubmitted != null) onSubmitted!();
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, size: 20),
                  contentPadding: EdgeInsets.only(right: 8),
                  hintText: 'Search reference',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  hoverColor: Colors.transparent,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
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
            color: Color.fromARGB(200, 140, 140, 140),
          ),
        );
      },
    );
  }
}
