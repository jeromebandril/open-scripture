import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/state/interface_visibility_cubit.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../../../../bible_display/bible_pane/presentation/state/bible_pane_bloc.dart';
import '../../../../bible_display/multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import '../../../../shortcuts/domain/models/app_command.dart';
import '../../../../shortcuts/presentation/models/app_command_shortcuts.dart';
import '../../../../shortcuts/presentation/widgets/shortcut_view.dart';
import '../../../search/presentation/state/search_bloc.dart';
import '../../domain/entities/history_entry.dart';
import '../cubit/history_cubit.dart';

// TODO: the entries traversal using the focus system is not smooth
// - it doesn't scroll bottom or top when looping the list
// - the focus persist on the last focused item, ideally it should reset top

enum HistoryListSize {
  small,
  big,
}

class HistoryList extends StatelessWidget {
  const HistoryList({
    super.key,
    this.onSelected,
    this.size = HistoryListSize.small,
  });

  final Function()? onSelected;
  final HistoryListSize size;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      buildWhen: (prev, curr) => prev.history != curr.history,
      builder: (context, state) {
        return FocusScope(
          autofocus: true,
          child: Shortcuts(
            shortcuts: const {
              SingleActivator(LogicalKeyboardKey.arrowUp):
                  _PreviousItemIntent(),
              SingleActivator(LogicalKeyboardKey.arrowDown): _NextItemIntent(),
            },
            child: Actions(
              actions: {
                _PreviousItemIntent: CallbackAction<_PreviousItemIntent>(
                  onInvoke: (_) => primaryFocus?.previousFocus(),
                ),
                _NextItemIntent: CallbackAction<_NextItemIntent>(
                  onInvoke: (_) => primaryFocus?.nextFocus(),
                ),
                DismissIntent: CallbackAction<DismissIntent>(
                  onInvoke: (_) {
                    context
                        .read<InterfaceVisibilityCubit>()
                        .setVisibility(history: false);
                    return null;
                  },
                ),
              },
              child: Column(
                spacing: 8,
                children: [
                  Expanded(
                    child: state.history.isEmpty
                        ? const Center(child: Text('Empty history'))
                        : ListView.builder(
                            itemCount: state.history.length,
                            itemBuilder: (_, i) => _HistoryItem(
                              index: i,
                              historyData: state.history[i],
                              autofocus: i == 0,
                              onPressed: () => onSelected?.call(),
                              size: size,
                            ),
                          ),
                  ),
                  SizedBox(
                    height: 25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 8,
                      children: [
                        Text('Press'),
                        ShortcutView(
                            activator:
                                appCommandShortcuts[AppCommand.toggleHistory]),
                        Text('to close'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PreviousItemIntent extends Intent {
  const _PreviousItemIntent();
}

class _NextItemIntent extends Intent {
  const _NextItemIntent();
}

class _HistoryItem extends StatefulWidget {
  const _HistoryItem({
    required this.index,
    required this.historyData,
    required this.autofocus,
    this.onPressed,
    required this.size,
  });

  final int index;
  final HistoryEntry historyData;
  final bool autofocus;
  final Function()? onPressed;
  final HistoryListSize size;

  @override
  State<_HistoryItem> createState() => _HistoryItemState();
}

class _HistoryItemState extends State<_HistoryItem> {
  final _focusNode = FocusNode(debugLabel: 'HistoryItem');
  bool _hasFocus = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final time = '${widget.historyData.time.hour.toString().padLeft(2, '0')}:'
        '${widget.historyData.time.minute.toString().padLeft(2, '0')}:'
        '${widget.historyData.time.second.toString().padLeft(2, '0')}';

    final refString = widget.size == HistoryListSize.small
        ? widget.historyData.ref.toString()
        : '${widget.historyData.ref.book.englishName} ${widget.historyData.ref.toStringChapterAndVerse()} ';

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.md),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        onFocusChange: (v) => setState(() => _hasFocus = v),
        focusColor: theme.colorScheme.primary.withValues(alpha: 0.08),
        hoverColor: theme.colorScheme.primary.withValues(alpha: 0.04),
        onTap: () {
          context.read<MultiPaneManagerCubit>().activePane().bloc.add(
                BiblePaneDisplayChapter(ref: widget.historyData.ref),
              );
          context
              .read<SearchBloc>()
              .add(SearchUpdateRef(widget.historyData.ref));
          widget.onPressed?.call();
          context.read<InterfaceVisibilityCubit>().toggleHistory();
        },
        child: SizedBox(
          height: 32,
          child: Row(
            spacing: 8,
            children: [
              _hasFocus
                  ? const SizedBox(
                      width: 20, child: Icon(Icons.arrow_right, size: 24))
                  : const SizedBox(width: 20),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          spacing: 12,
                          children: [
                            Text(time,
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(fontFamily: 'IBM Plex Mono')),
                            Text(refString,
                                style: theme.textTheme.labelMedium?.copyWith(
                                    fontFamily: 'IBM Plex Mono',
                                    color: theme.colorScheme.primary)),
                          ],
                        ),
                      ),
                    ),
                    if (_hasFocus)
                      IconButton(
                        // Skip focus, so user can navigate smoothly
                        focusNode: FocusNode(
                          canRequestFocus: false,
                          skipTraversal: true,
                        ),
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.remove_circle, size: 18),
                        onPressed: () =>
                            context.read<HistoryCubit>().remove(widget.index),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
