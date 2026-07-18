import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../../shared/domain/entities/bible_ref.dart';
import '../../../../../shared/domain/entities/verse.dart';
import '../../../../customizer/presentation/models/bible_pane_general_theme.dart';
import '../../../../customizer/presentation/models/bible_view_list_theme.dart';
import '../../../multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import '../cubit/selected_word_cubit.dart';
import '../rendering/verse_ref_label.dart';
import '../rendering/verse_richtext_builder.dart';
import '../state/bible_pane_bloc.dart';
import 'verse_divider.dart';

class BibleViewList extends StatefulWidget {
  const BibleViewList({
    super.key,
    required this.uniqueId,
    this.onVerseTap,
  });

  final int uniqueId;
  final void Function(BibleRef ref)? onVerseTap;

  @override
  State<BibleViewList> createState() => _BibleViewListState();
}

class _BibleViewListState extends State<BibleViewList> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  bool _scrollScheduled = false;
  BibleRef? _pendingScrollRef;

  bool _isIndexVisible(int index, Iterable<ItemPosition> positions) {
    return positions.any(
      (p) =>
          p.index == index && p.itemLeadingEdge > 0 && p.itemTrailingEdge < 1,
    );
  }

  void _scheduleScrollAfterBuild({
    required List<BibleRef> items,
    bool useAnimation = true,
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final bloc = context.read<BiblePaneBloc>();
      final initialRef = bloc.state.reference;
      if (initialRef == null) return;

      _pendingScrollRef = initialRef.copyWith(verseEnd: () => null);
      _scheduleScrollAfterBuild(
        items: bloc.state.unionRefs.toList(),
        useAnimation: false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);
    final panes = context.read<MultiPaneManagerCubit>().state.panes;
    final thisPaneIndex = panes.indexWhere((e) => e.id == widget.uniqueId);
    final paneTheme = Theme.of(context).extension<BiblePaneGeneralTheme>()!;

    return BlocConsumer<BiblePaneBloc, BiblePaneState>(
      listenWhen: (prev, curr) =>
          (prev.reference != curr.reference && curr.reference != null),
      listener: (context, state) {
        final ref = state.reference;
        if (ref == null) return;
        _pendingScrollRef = ref.copyWith(verseEnd: () => null);
        _scheduleScrollAfterBuild(items: state.unionRefs.toList());
      },
      buildWhen: (prev, curr) =>
          prev.reference != curr.reference || prev.content != curr.content,
      builder: (context, state) {
        final content = state.content;
        final unionRefs = content.computeUnion();

        return ScrollablePositionedList.separated(
          itemScrollController: _itemScrollController,
          itemPositionsListener: _itemPositionsListener,
          itemCount: unionRefs.length + 1,
          padding: const EdgeInsets.only(top: 16),
          separatorBuilder: (ctx, _) => const VerseDivider(),
          itemBuilder: (_, i) {
            if (i == unionRefs.length) return const SizedBox(height: 200);

            final ref = unionRefs.elementAt(i);
            final verses = state.parallelOrder
                .map((id) => content.getParallelDataByBibleId(id)?.verses?[ref])
                .toList();
            final isHighlighted = state.reference == null
                ? false
                : state.reference!.contains(ref);

            return Padding(
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
                onVerseTap: widget.onVerseTap,
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
    this.onVerseTap,
  });

  final BibleRef ref;
  final List<Verse?> verses;
  final bool isHighlighted;
  final void Function(BibleRef ref)? onVerseTap;

  @override
  Widget build(BuildContext context) {
    final spacing =
        Theme.of(context).extension<BibleViewListTheme>()!.parallelSpacing;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: spacing,
      children: verses.map((v) {
        if (v == null) return const Expanded(child: SizedBox());

        return Expanded(
          child: _VerseWidget(
            verse: v,
            isHighlighted: isHighlighted,
            onVerseTap: onVerseTap,
          ),
        );
      }).toList(),
    );
  }
}

class _VerseWidget extends StatelessWidget {
  final Verse verse;
  final bool isHighlighted;
  final void Function(BibleRef ref)? onVerseTap;

  const _VerseWidget({
    required this.verse,
    this.isHighlighted = false,
    this.onVerseTap,
  });

  @override
  Widget build(BuildContext context) {
    final bTheme = Theme.of(context).extension<BiblePaneGeneralTheme>()!;
    final listTheme = Theme.of(context).extension<BibleViewListTheme>()!;

    final refLabel = VerseRefLabel.text(
      verse.ref,
      isHighlighted: isHighlighted,
      showFullRefAlways: listTheme.showFullRefAlways,
    );
    final refStyle = VerseRefLabel.style(context, isHighlighted: isHighlighted);

    final headingStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: bTheme.refColor,
      height: 2.0,
    );

    return Listener(
      onPointerDown: onVerseTap == null
          ? null
          : (_) => onVerseTap!(verse.ref.copyWith(verseEnd: () => null)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SelectableText.rich(
              TextSpan(
                style: TextStyle(
                  height: 1.25,
                  fontWeight: bTheme.textFontWeight,
                ),
                children: [
                  TextSpan(text: refLabel, style: refStyle),
                  const TextSpan(text: '  '),
                  ..._buildSegmentSpans(context, headingStyle),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<InlineSpan> _buildSegmentSpans(
    BuildContext context,
    TextStyle headingStyle,
  ) {
    final result = <InlineSpan>[];

    for (var i = 0; i < verse.segments.length; i++) {
      final segment = verse.segments[i];

      // Paragraph break; only insert if not the very first segment
      if (segment.isParagraphStart && i > 0) {
        result.add(const TextSpan(text: '\n'));
      }

      // Section heading above this segment
      if (segment.heading != null) {
        result.add(TextSpan(
          text: '${segment.heading}\n',
          style: headingStyle,
        ));
      }

      // The actual spans
      result.addAll(
        VerseSpanBuilder.build(
          spans: segment.spans,
          context: context,
          onWordTap: (VerseSpan span) =>
              context.read<SelectedWordCubit>().setSelectedWord(
                    WordInfo(span: span, text: span.text),
                  ),
        ),
      );
    }

    return result;
  }
}
