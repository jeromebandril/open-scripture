import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:the_smyrna_bible_v2/core/domain/entities/bible_ref.dart';

import '../../../../../core/domain/entities/verse_segment.dart';
import '../../../../customizer/domain/entities/bible_pane_theme.dart';
import '../../../split_screen/presenter/cubit/pane_manager_cubit.dart';
import '../bloc/bible_pane_bloc.dart';
import 'parts/verse_divider.dart';
import 'parts/verse_widget.dart';

class BibleViewList extends StatefulWidget {
  const BibleViewList({
    super.key,
    required this.segments,
    required this.uniqueId,
  });

  final int uniqueId;
  final List<VerseSegment> segments;

  @override
  State<BibleViewList> createState() => _BibleViewListState();
}

class _BibleViewListState extends State<BibleViewList> {
  late ItemScrollController _itemScrollController;
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _itemScrollController = ItemScrollController();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _isMounted = context.mounted,
    );
  }

  bool _isIndexVisible(int index) {
    final positions = _itemPositionsListener.itemPositions.value;
    return positions.any((p) {
      return p.index == index &&
          p.itemLeadingEdge > 0 &&
          p.itemTrailingEdge < 1;
    });
  }

  void _scrollUntilVisible(int index) {
    if (!_isMounted) return;
    if (index < 0) return;
    // Optional guard: only scroll if out of view
    if (!_isIndexVisible(index)) {
      if (_itemScrollController.isAttached) {
        _itemScrollController.scrollTo(
            index: index,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: 0.1);
      }
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
    final paneTheme = Theme.of(context).extension<BiblePaneTheme>()!;

    return BlocConsumer<BiblePaneBloc, BiblePaneState>(
      listenWhen: (prev, curr) =>
          prev.reference != curr.reference && curr.reference != null,
      listener: (context, state) =>
          _scrollUntilVisible(verseRefs.indexOf(state.reference!)),
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
                        ref.verseEnd! <= vEnd);

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
