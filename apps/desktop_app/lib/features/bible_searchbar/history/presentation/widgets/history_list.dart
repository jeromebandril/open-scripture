import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/app/state/interface_visibility_cubit.dart';
import 'package:open_scripture/core/infrastructure/book_resolver/book_resolver.dart';
import 'package:open_scripture/features/bible_searchbar/history/presentation/cubit/history_cubit.dart';
import 'package:open_scripture/features/shortcuts/domain/models/app_command.dart';
import 'package:open_scripture/features/shortcuts/presentation/widgets/shortcut_view.dart';

import '../../../../../injection_container.dart';
import '../../../../bible_display/bible_pane/presentation/state/bible_pane_bloc.dart';
import '../../../../bible_display/multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import '../../../../shortcuts/presentation/models/app_command_shortcuts.dart';
import '../../../search/presentation/state/search_bloc.dart';
import '../../domain/entities/history_entry.dart';

enum HistoryListSize {
  small,
  big,
}

// Wrapper for history

class HistoryList extends StatelessWidget {
  const HistoryList({
    super.key,
    this.onSelected,
    this.size = HistoryListSize.small,
    this.focusNode,
  });

  final Function()? onSelected;
  final HistoryListSize size;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      buildWhen: (prev, curr) => prev.history != curr.history,
      builder: (context, state) {
        return Focus(
          focusNode: focusNode,
          child: Column(
            spacing: 8,
            children: [
              Expanded(
                child: state.history.isEmpty
                    ? Center(child: Text('Empty history'))
                    : ListView.builder(
                        itemCount: state.history.length,
                        itemBuilder: (_, i) {
                          return _HistoryItem(
                            index: i,
                            historyData: state.history[i],
                            onPressed: () => onSelected?.call(),
                            size: size,
                          );
                        }),
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
              )
            ],
          ),
        );
      },
    );
  }
}

class _HistoryItem extends StatefulWidget {
  const _HistoryItem({
    required this.index,
    required this.historyData,
    this.onPressed,
    required this.size,
  });

  final int index;
  final HistoryEntry historyData;
  final Function()? onPressed;
  final HistoryListSize size;

  @override
  State<_HistoryItem> createState() => _HistoryItemState();
}

class _HistoryItemState extends State<_HistoryItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    String time = '${widget.historyData.time.hour.toString().padLeft(2, '0')}:'
        '${widget.historyData.time.minute.toString().padLeft(2, '0')}:'
        '${widget.historyData.time.second.toString().padLeft(2, '0')}';

    final resolver = sl<BibleRefResolver>();

    final refString = widget.size == HistoryListSize.small
        ? widget.historyData.ref.toString()
        : widget.historyData.ref.toString().replaceFirst(
              widget.historyData.ref.bookUsfxId,
              resolver
                      .resolveBook(widget.historyData.ref.bookUsfxId)
                      ?.fullName ??
                  'error',
            );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: SizedBox(
        height: 32,
        child: Row(
          spacing: 8,
          children: [
            _isHovered
                ? const SizedBox(
                    width: 20, child: Icon(Icons.arrow_right, size: 24))
                : const SizedBox(width: 20),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        context
                            .read<MultiPaneManagerCubit>()
                            .activePane()
                            .bloc
                            .add(
                              BiblePaneDisplayChapter(
                                  ref: widget.historyData.ref),
                            );
                        context
                            .read<SearchBloc>()
                            .add(SearchUpdateRef(widget.historyData.ref));
                        widget.onPressed?.call();
                        context
                            .read<InterfaceVisibilityCubit>()
                            .toggleHistory();
                      },
                      child: Row(
                        spacing: 12,
                        children: [
                          Text(
                            time,
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'IBM Plex Mono'),
                          ),
                          Text(
                            refString,
                            style: const TextStyle(fontFamily: 'IBM Plex Mono'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_isHovered)
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: Icon(Icons.remove_circle, size: 18),
                      onPressed: () =>
                          context.read<HistoryCubit>().remove(widget.index),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
