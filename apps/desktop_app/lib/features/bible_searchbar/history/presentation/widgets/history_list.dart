import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../app/state/interface_visibility_cubit.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../../../../bible_display/bible_pane/presentation/state/bible_pane_bloc.dart';
import '../../../../bible_display/multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import '../../../search/presentation/state/search_bloc.dart';
import '../../domain/entities/history_entry.dart';
import '../state/history_cubit.dart';

enum HistoryListSize { small, big }

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
    final history = context.select((HistoryCubit c) => c.state.history);

    return FocusScope(
      autofocus: true,
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Column(
          spacing: AppSpacing.sm,
          children: [
            Expanded(
              child: history.isEmpty
                  ? const Center(child: Text('Empty history'))
                  : ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (_, i) => _HistoryItem(
                        index: i,
                        autofocus: i == 0,
                        historyData: history[i],
                        onPressed: () => onSelected?.call(),
                        size: size,
                      ),
                    ),
            ),
            const Divider(),
            SizedBox(
              height: 22,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: AppSpacing.sm,
                children: [
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: Icon(LucideIcons.close),
                  // ),
                  IconButton(
                    onPressed: () => context.read<HistoryCubit>().clearAll(),
                    // tooltip: 'Clear all',
                    icon: const Icon(LucideIcons.broom),
                  ),
                  IconButton(
                    onPressed: () => context
                        .read<InterfaceVisibilityCubit>()
                        .toggleHistory(),
                    // tooltip: 'Close',
                    icon: const Icon(LucideIcons.x),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
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
  bool _isHovered = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = 30.0;
    final theme = Theme.of(context);
    final timeStr =
        '${widget.historyData.time.hour.toString().padLeft(2, '0')}:'
        '${widget.historyData.time.minute.toString().padLeft(2, '0')}';
    final refStr = widget.size == HistoryListSize.small
        ? widget.historyData.ref.toString()
        : '${widget.historyData.ref.book.englishName} ${widget.historyData.ref.toStringChapterAndVerse()} ';

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.md),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        onHover: (v) => setState(() => _isHovered = v),
        onFocusChange: (v) => setState(() => _hasFocus = v),
        focusColor: theme.colorScheme.primary.withValues(alpha: 0.1),
        hoverColor: theme.colorScheme.primary.withValues(alpha: 0.1),
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
          height: height,
          child: Row(
            children: [
              SizedBox(
                width: 36,
                child: _hasFocus || _isHovered
                    ? const Icon(Icons.arrow_right, size: 24)
                    : null,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                spacing: AppSpacing.md,
                children: [
                  Text(
                    timeStr,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: AppTypography.fontFamilyMono,
                    ),
                  ),
                  Text(
                    refStr,
                    style: theme.textTheme.labelMedium,
                  ),
                ],
              ),
              const Spacer(),
              if (_isHovered)
                IconButton(
                  focusNode: FocusNode(
                    canRequestFocus: false,
                    skipTraversal: true,
                  ),
                  icon: const Icon(Icons.remove_circle, size: 18),
                  onPressed: () =>
                      context.read<HistoryCubit>().remove(widget.index),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
