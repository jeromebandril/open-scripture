import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:open_scripture/shared/domain/entities/bible_ref.dart';

import '../../../../../shared/domain/entities/verse_segment.dart';
import '../../../../customizer/presentation/models/bible_pane_general_theme.dart';
import '../../../split_screen/presenter/cubit/pane_manager_cubit.dart';
import '../bloc/bible_pane_bloc.dart';
import 'parts/verse_divider.dart';
import 'parts/verse_widget.dart';

class BibleViewList extends StatefulWidget {
  const BibleViewList({
    super.key,
    required this.uniqueId,
    required this.segments,
  });

  final int uniqueId;
  final List<VerseSegment> segments;

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

  void _scheduleScrollAfterBuild({useAnimation = true}) {
    if (_scrollScheduled) return;
    _scrollScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _scrollScheduled = false;
      if (!mounted) return;

      final target = _pendingScrollRef;
      if (target == null) return;

      final segmentsByVerse = <BibleRef, List<VerseSegment>>{};
      for (final s in widget.segments) {
        final key = s.ref;
        (segmentsByVerse[key] ??= <VerseSegment>[]).add(s);
      }
      final refs = segmentsByVerse.keys.toList();

      final index = refs.indexOf(target);
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
        alignment: 0.1,
      );
      return;
    }

    _itemScrollController.jumpTo(index: index, alignment: 0.04);
  }

  @override
  void initState() {
    super.initState();

    // Scrolls to ref after display mode switch (which should remount the widget)
    _pendingScrollRef =
        context.read<BiblePaneBloc>().state.reference!.copyWith(verseEnd: null);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduleScrollAfterBuild(useAnimation: false);
    });
  }

  @override
  void didUpdateWidget(covariant BibleViewList oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Scrolls to ref after content segments changes
    if (!identical(oldWidget.segments, widget.segments)) {
      _scheduleScrollAfterBuild();
    }
  }

  @override
  Widget build(BuildContext context) {
    // group segments by verse
    final segmentsByVerse = <BibleRef, List<VerseSegment>>{};
    for (final s in widget.segments) {
      final key = s.ref;
      (segmentsByVerse[key] ??= <VerseSegment>[]).add(s);
    }
    final verseRefs = segmentsByVerse.keys.toList(); //..sort();

    // Set padding
    final screen = MediaQuery.of(context).size;
    final panes = context.read<PaneManagerCubit>().state.panes;
    final thisPaneIndex = panes.indexWhere((e) => e.id == widget.uniqueId);

    // theming
    final paneTheme = Theme.of(context).extension<BiblePaneGeneralTheme>()!;

    return BlocConsumer<BiblePaneBloc, BiblePaneState>(
      listenWhen: (prev, curr) =>
          (prev.reference != curr.reference && curr.reference != null),
      listener: (context, state) {
        final ref = state.reference;
        if (ref == null) return;

        _pendingScrollRef = ref.copyWith(verseEnd: null);

        _scheduleScrollAfterBuild();
      },
      buildWhen: (prev, curr) => prev.reference != curr.reference,
      builder: (context, state) {
        return ScrollablePositionedList.separated(
          itemScrollController: _itemScrollController,
          itemPositionsListener: _itemPositionsListener,
          itemCount: verseRefs.length + 1,
          padding: EdgeInsets.only(top: 16),
          separatorBuilder: (ctx, _) {
            return VerseDivider();
          },
          itemBuilder: (_, i) {
            // Fixed empty space at the bottom
            if (i == verseRefs.length) {
              return SizedBox(
                height: 200,
                child: state.isMixed
                    ? Align(
                        alignment: AlignmentGeometry.center,
                        child: Text(
                          '${state.segments.length} results found',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.outline),
                        ),
                      )
                    : null,
              );
            }

            // Set content
            final ref = verseRefs[i];
            final segments = segmentsByVerse[ref]!;
            final spans = segments.expand((s) => s.spans).toList();
            // Selected verse
            final vStart = state.reference?.verseStart;
            final vEnd = state.reference?.verseEnd;

            // highlight a range only if verses are of the same book and chapter
            final isHighlighted = state.isMixed
                ? state.reference == ref
                : (vEnd == null && ref.verseStart == vStart) ||
                    (vEnd != null &&
                        vStart != null &&
                        ref.verseStart! >= vStart &&
                        ref.verseStart! <= vEnd);

            return Padding(
              padding: EdgeInsets.only(
                left:
                    thisPaneIndex == 0 ? screen.width * paneTheme.xPadding : 0,
                right: thisPaneIndex == panes.length - 1
                    ? screen.width * paneTheme.xPadding
                    : 0,
              ),
              child: VerseWidget(
                reference: ref,
                segments: segments,
                spans: spans,
                isHighlighted: isHighlighted,
              ),
            );
          },
        );
      },
    );
  }
}

class ChooseIntent extends Intent {
  const ChooseIntent();
}
