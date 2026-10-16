import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../../app/extensions/font_weight.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../../../../../shared/domain/entities/bible_ref.dart';
import '../../../../../shared/domain/entities/verse.dart';
import '../../../../../shared/presentation/models/display_option_flutter.dart';
import '../../../settings/presentation/widgets/bible_view_settings_provider.dart';
import '../rendering/verse_ref_label.dart';
import '../rendering/verse_richtext_builder.dart';
import '../state/bible_pane_bloc.dart';
import 'verse_divider.dart';

class BibleViewList extends StatefulWidget {
  const BibleViewList({
    super.key,
    required this.uniqueId,
    this.autoscroll = true,
    this.onVerseTap,
    this.onStrongWordTap,
  });

  final int uniqueId;
  final bool autoscroll;
  final ValueChanged<BibleRef>? onVerseTap;
  final ValueChanged<VerseSpan>? onStrongWordTap;

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
    if (!widget.autoscroll) return;
    if (_scrollScheduled) return;
    _scrollScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _scrollScheduled = false;
      if (!mounted) return;
      if (!widget.autoscroll) return;

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
        final unionRefs = state.unionRefs;

        return ScrollablePositionedList.separated(
          itemScrollController: _itemScrollController,
          itemPositionsListener: _itemPositionsListener,
          itemCount: unionRefs.length,
          padding: EdgeInsets.only(
            top: 16,
            bottom: 200,
            left: AppSpacing.md,
            right: AppSpacing.md,
          ),
          separatorBuilder: (ctx, _) => const VerseDivider(),
          itemBuilder: (_, i) {
            final ref = unionRefs.elementAt(i);
            final verses = state.parallelOrder
                .map((id) => content.getParallelDataByBibleId(id)?.verses?[ref])
                .toList();
            final isHighlighted = state.reference == null
                ? false
                : state.reference!.contains(ref);

            return _ParallelView(
              ref: ref,
              isHighlighted: isHighlighted,
              verses: verses,
              onVerseTap: widget.onVerseTap,
              onStrongWordTap: widget.onStrongWordTap,
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
    this.onStrongWordTap,
  });

  final BibleRef ref;
  final List<Verse?> verses;
  final bool isHighlighted;
  final ValueChanged<BibleRef>? onVerseTap;
  final ValueChanged<VerseSpan>? onStrongWordTap;

  @override
  Widget build(BuildContext context) {
    final spacing = BibleViewSettingsScope.of(context).listParallelSpacing;
    final enablePericope = BibleViewSettingsScope.of(context).enablePericope;

    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: spacing.toDouble(),
      children: verses.map((v) {
        if (v == null) return const Expanded(child: SizedBox());

        return Expanded(
          child: _VerseWidget(
            verse: v,
            isHighlighted: isHighlighted,
            onVerseTap: onVerseTap,
            onStrongWordTap: onStrongWordTap,
          ),
        );
      }).toList(),
    );

    if (!enablePericope) return row;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        _PericopeRow(verses: verses, spacing: spacing.toDouble()),
        row,
      ],
    );
  }
}

class _VerseWidget extends StatelessWidget {
  final Verse verse;
  final bool isHighlighted;
  final ValueChanged<BibleRef>? onVerseTap;
  final ValueChanged<VerseSpan>? onStrongWordTap;

  const _VerseWidget({
    required this.verse,
    this.isHighlighted = false,
    this.onVerseTap,
    this.onStrongWordTap,
  });

  @override
  Widget build(BuildContext context) {
    final viewSettings = BibleViewSettingsScope.of(context);
    final viewColors = BibleViewSettingsScope.colorschemeOf(context);

    final refLabel = VerseRefLabel.text(
      verse.ref,
      isHighlighted: isHighlighted,
      showFullRefAlways: viewSettings.showAlwaysFullRef,
    );
    final refStyle = VerseRefLabel.style(context, isHighlighted: isHighlighted);

    final headingStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: viewColors.refColor,
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
                children: [
                  TextSpan(text: refLabel, style: refStyle),
                  const TextSpan(text: '  '),
                  ..._buildSegmentSpans(context, headingStyle, onStrongWordTap),
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
    ValueChanged<VerseSpan>? onStrongWordTap,
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
          onWordTap: onStrongWordTap,
        ),
      );
    }

    return result;
  }
}

class _PericopeRow extends StatelessWidget {
  const _PericopeRow({required this.verses, required this.spacing});

  final List<Verse?> verses;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    if (verses.every((v) => v?.heading == null)) {
      return const SizedBox.shrink();
    }

    final viewSettings = BibleViewSettingsScope.of(context);
    final viewColors = BibleViewSettingsScope.colorschemeOf(context);

    // Inherit the verse text style so the title follows the font-size setting.
    final style = DefaultTextStyle.of(context).style.copyWith(
          fontWeight: viewSettings.verseFontWeight.toFlutter().stepUp(steps: 1),
          color: viewColors.pericopeColor,
          decorationColor: viewColors.pericopeColor,
          decoration:
              viewSettings.pericopeUnderline ? TextDecoration.underline : null,
        );

    final textScaler = MediaQuery.textScalerOf(context);

    return Padding(
      padding: EdgeInsets.only(
        top: viewSettings.pericopeSpacingBefore * textScaler.scale(1.0),
        bottom: viewSettings.pericopeSpacingAfter * textScaler.scale(1.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: spacing,
        children: verses.map((v) {
          final title = v?.heading;
          return Expanded(
            child: title == null
                ? const SizedBox()
                : Text(title, style: style, textAlign: TextAlign.center),
          );
        }).toList(),
      ),
    );
  }
}
