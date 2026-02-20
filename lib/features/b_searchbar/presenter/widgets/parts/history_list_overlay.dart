import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/shortcuts/domain/app_command.dart';
import 'package:open_scripture/features/shortcuts/presentation/widget/shortcut_view.dart';

import '../../../../../shared/domain/entities/book_names.dart';
import '../../../../../injection_container.dart';
import '../../../../bible_display/bible_pane/presentation/bloc/bible_pane_bloc.dart';
import '../../../../bible_display/split_screen/presenter/cubit/pane_manager_cubit.dart';
import '../../../../shortcuts/presentation/models/app_command_shortcuts.dart';
import '../../bloc/b_searchbar_bloc.dart';
import '../../models/history_data.dart';

enum HistoryListSize {
  small,
  big,
}

class HistoryListOverlay extends StatelessWidget {
  const HistoryListOverlay({
    super.key,
    required this.constraints,
    this.onSelected,
    this.width,
    this.size = HistoryListSize.small,
    this.focusNode,
  });

  final Size constraints;
  final double? width;
  final Function()? onSelected;
  final HistoryListSize size;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BSearchbarBloc, BSearchbarState>(
      buildWhen: (prev, curr) => prev.history != curr.history,
      builder: (context, state) {
        return BlockSemantics(
          blocking: true,
          child: Focus(
            focusNode: focusNode,
            child: Container(
              width: width ?? 250,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints.loose(Size(
                  constraints.width,
                  constraints.height * .2,
                )),
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
                              activator: appCommandShortcuts[
                                  AppCommand.toggleHistory]),
                          Text('to close'),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
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
  final HistoryData historyData;
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
                    width: 20,
                    child: Icon(
                      Icons.arrow_right,
                      size: 24,
                    ))
                : const SizedBox(
                    width: 20,
                  ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        context.read<PaneManagerCubit>().activePane().bloc.add(
                              BiblePaneDisplayChapter(
                                  ref: widget.historyData.ref),
                            );
                        widget.onPressed?.call();
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
                      onPressed: () => context
                          .read<BSearchbarBloc>()
                          .add(DeleteHistoryItem(widget.index)),
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
