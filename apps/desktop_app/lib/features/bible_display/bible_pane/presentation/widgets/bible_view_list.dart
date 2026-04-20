import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/customizer/presentation/models/bible_view_list_theme.dart';
import 'package:open_scripture/shared/domain/entities/verse.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:open_scripture/shared/domain/entities/bible_ref.dart';

import '../../../../customizer/presentation/models/bible_pane_general_theme.dart';
import '../../../split_screen/presenter/cubit/pane_manager_cubit.dart';
import '../bloc/bible_pane_bloc.dart';
import 'parts/verse_divider.dart';
import 'parts/verse_widget.dart';

class BibleViewList extends StatefulWidget {
  const BibleViewList({super.key, required this.uniqueId});

  final int uniqueId;

  @override
  State<BibleViewList> createState() => _BibleViewListState();
}

class _BibleViewListState extends State<BibleViewList> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  bool _scrollScheduled = false;
  BibleRef? _pendingScrollRef;

  bool _isIndexVisible(int index, Iterable<ItemPosition>? p) {
    final positions = _itemPositionsListener.itemPositions.value;
    return positions.any((p) {
      return p.index == index &&
          p.itemLeadingEdge > 0 &&
          p.itemTrailingEdge < 1;
    });
  }

  void _scheduleScrollAfterBuild({
    required List<BibleRef> items,
    useAnimation = true,
  }) {
    if (_scrollScheduled) return;
    _scrollScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _scrollScheduled = false;
      if (!mounted) return;

      final target = _pendingScrollRef;
      if (target == null) return;

      final index = items.indexOf(target);
      if (index < 0) return;

      await _scrollWhenReady(index, useAnimation);
    });
  }

  Future<void> _scrollWhenReady(int index, bool useAnimation) async {
    // wait up to ~10 frames for attachment + positions
    for (var i = 0; i < 10; i++) {
      if (!mounted) return;

      if (_itemScrollController.isAttached &&
          _itemPositionsListener.itemPositions.value.isNotEmpty) {
        break;
      }
      await Future<void>.delayed(const Duration(milliseconds: 16));
    }

    if (!mounted || !_itemScrollController.isAttached) return;

    final positions = _itemPositionsListener.itemPositions.value;
    if (_isIndexVisible(index, positions)) return;

    if (useAnimation) {
      await _itemScrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        alignment: 0.03,
      );
      return;
    }

    _itemScrollController.jumpTo(index: index, alignment: 0.04);
  }

  @override
  void initState() {
    super.initState();

    // Scrolls to ref after display mode switch (which should remount the widget)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<BiblePaneBloc>();
      final items = bloc.state.unionRefs.toList();
      _pendingScrollRef = bloc.state.reference!.copyWith(verseEnd: null);
      _scheduleScrollAfterBuild(items: items, useAnimation: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Set padding
    final screen = MediaQuery.of(context).size;
    final panes = context.read<PaneManagerCubit>().state.panes;
    final thisPaneIndex = panes.indexWhere((e) => e.id == widget.uniqueId);
    // theming
    final paneTheme = Theme.of(context).extension<BiblePaneGeneralTheme>()!;

    return BlocConsumer<BiblePaneBloc, BiblePaneState>(
      //
      // This is for auto scroll to item (verse) until visible
      //
      listenWhen: (prev, curr) =>
          (prev.reference != curr.reference && curr.reference != null),
      listener: (context, state) {
        final ref = state.reference;
        if (ref == null) return;
        _pendingScrollRef = ref.copyWith(verseEnd: null);
        _scheduleScrollAfterBuild(items: state.unionRefs.toList());
      },
      //
      // Should rebuild only when content or selected ref change.
      //
      buildWhen: (prev, curr) =>
          prev.reference != curr.reference || prev.content != curr.content,
      builder: (context, state) {
        final content = state.content;
        final unionRefs = content.computeUnion();

        return ScrollablePositionedList.separated(
          itemScrollController: _itemScrollController,
          itemPositionsListener: _itemPositionsListener,
          itemCount: unionRefs.length + 1,
          padding: EdgeInsets.only(top: 16),
          separatorBuilder: (ctx, _) => const VerseDivider(),
          itemBuilder: (_, i) {
            //
            // Empty space fixed at the bottom
            //
            if (i == unionRefs.length) return SizedBox(height: 200);

            // Get verse and its variants in a preferred order
            final ref = unionRefs.elementAt(i);
            final verses = state.parallelOrder
                .map((id) => content.getParallelDataByBibleId(id)?.verses?[ref])
                .toList();
            final isHighlighted = state.reference == null
                ? false
                : ref.contains(state.reference!);

            return Padding(
              //
              // These paddings are set from app level customization settings,
              // but they need to be here even if its ugly
              //
              padding: EdgeInsets.only(
                left:
                    thisPaneIndex == 0 ? screen.width * paneTheme.xPadding : 0,
                right: thisPaneIndex == panes.length - 1
                    ? screen.width * paneTheme.xPadding
                    : 0,
              ),
              child: _ParallelView(
                ref: ref,
                isHighlighted: isHighlighted,
                verses: verses,
              ),
            );
          },
        );
      },
    );
  }
}

class _ParallelView extends StatelessWidget {
  const _ParallelView({
    required this.verses,
    required this.ref,
    this.isHighlighted = false,
  });

  final BibleRef ref;
  final List<Verse?> verses;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final spacing =
        Theme.of(context).extension<BibleViewListTheme>()!.parallelSpacing;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: spacing,
      children: [
        ...verses.map((v) {
          if (v == null) return SizedBox();

          final spans = v.segments.expand((s) => s.spans).toList();

          final verseWidget = VerseWidget(
            reference: ref,
            segments: v.segments,
            spans: spans,
            isHighlighted: isHighlighted,
          );

          return Expanded(child: verseWidget);
        }),
      ],
    );
  }
}
