import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/domain/entities/bible_ref.dart';
import '../../../../../shared/domain/entities/verse.dart';
import '../../../../customizer/presentation/models/bible_pane_general_theme.dart';
import '../../../../customizer/presentation/models/bible_view_list_theme.dart';
import '../../../../customizer/presentation/state/customizer_cubit.dart';
import '../../../multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import '../../domain/entities/word_info.dart';
import '../rendering/verse_ref_label.dart';
import '../rendering/verse_richtext_builder.dart';
import '../state/bible_pane_bloc.dart';

/// A "continuous" reading view: verses flow together as ordinary prose,
/// broken only where the data says a paragraph or heading starts.
class BibleViewProse extends StatefulWidget {
  const BibleViewProse({
    super.key,
    required this.uniqueId,
    this.onVerseTap,
  });

  final int uniqueId;
  final void Function(BibleRef ref)? onVerseTap;

  @override
  State<BibleViewProse> createState() => _BibleViewProseState();
}

class _BibleViewProseState extends State<BibleViewProse> {
  final Map<int, ScrollController> _scrollControllers = {};
  final Map<int, Map<BibleRef, GlobalKey>> _verseAnchors = {};

  bool _isSyncingScroll = false;
  BibleRef? _pendingScrollRef;
  bool _scrollScheduled = false;

  ScrollController _controllerFor(int column) {
    return _scrollControllers.putIfAbsent(column, () {
      final controller = ScrollController();
      controller.addListener(() => _syncColumns(column));
      return controller;
    });
  }

  Map<BibleRef, GlobalKey> _anchorsFor(int column) {
    return _verseAnchors.putIfAbsent(column, () => {});
  }

  /// Keeps parallel columns roughly aligned by scroll *fraction*. Since each
  /// translation can wrap into a different number of lines, this can't
  /// guarantee the same verse sits at the same height in every column, but
  /// only that all columns sit at "the same relative depth" through their
  /// own text
  void _syncColumns(int sourceColumn) {
    if (_isSyncingScroll) return;
    final source = _scrollControllers[sourceColumn];
    if (source == null || !source.hasClients) return;

    final maxSource = source.position.maxScrollExtent;
    final fraction =
        maxSource <= 0 ? 0.0 : (source.offset / maxSource).clamp(0.0, 1.0);

    _isSyncingScroll = true;
    try {
      for (final entry in _scrollControllers.entries) {
        if (entry.key == sourceColumn) continue;
        final controller = entry.value;
        if (!controller.hasClients) continue;
        final target = fraction * controller.position.maxScrollExtent;
        controller.jumpTo(target);
      }
    } finally {
      _isSyncingScroll = false;
    }
  }

  void _scheduleScrollToRef(BibleRef ref) {
    _pendingScrollRef = ref;
    if (_scrollScheduled) return;
    _scrollScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryScrollToPending());
  }

  Future<void> _tryScrollToPending() async {
    _scrollScheduled = false;
    final target = _pendingScrollRef;
    if (target == null || !mounted) return;

    // Scroll relative to the first (primary) column; synced columns follow.
    final anchors = _anchorsFor(0);

    for (var i = 0; i < 10; i++) {
      if (!mounted) return;
      final key = anchors[target];
      if (key?.currentContext != null) {
        await Scrollable.ensureVisible(
          key!.currentContext!,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: 0.25,
        );
        return;
      }
      await Future<void>.delayed(const Duration(milliseconds: 16));
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final bloc = context.read<BiblePaneBloc>();
      final initialRef = bloc.state.reference;
      if (initialRef == null) return;
      _scheduleScrollToRef(initialRef.copyWith(verseEnd: () => null));
    });
  }

  @override
  void dispose() {
    for (final controller in _scrollControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onStrongsWordTap(BuildContext context, VerseSpan span) {
    context
        .read<BiblePaneBloc>()
        .add(BiblePaneSelectWord(WordInfo(span: span, text: span.text)));
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);
    final panes = context.read<MultiPaneManagerCubit>().state.panes;
    final thisPaneIndex = panes.indexWhere((e) => e.id == widget.uniqueId);
    final paneTheme = Theme.of(context).extension<BiblePaneGeneralTheme>()!;
    final listTheme = Theme.of(context).extension<BibleViewListTheme>()!;

    return BlocConsumer<BiblePaneBloc, BiblePaneState>(
      listenWhen: (prev, curr) =>
          (prev.reference != curr.reference && curr.reference != null),
      listener: (context, state) {
        final ref = state.reference;
        if (ref == null) return;
        _scheduleScrollToRef(ref.copyWith(verseEnd: () => null));
      },
      buildWhen: (prev, curr) =>
          prev.reference != curr.reference || prev.content != curr.content,
      builder: (context, state) {
        final parallelOrder = state.parallelOrder.toList();
        final ref = state.reference;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              child: Text(
                '${ref?.book.englishName} ${ref?.chapter}',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: paneTheme.accentColor),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: thisPaneIndex == 0
                      ? screen.width * paneTheme.xPadding
                      : 0,
                  right: thisPaneIndex == panes.length - 1
                      ? screen.width * paneTheme.xPadding
                      : 0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: listTheme.parallelSpacing,
                  children: [
                    for (var col = 0; col < parallelOrder.length; col++)
                      Expanded(
                        child: _buildColumn(
                            context, state, col, parallelOrder[col]),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildColumn(
    BuildContext context,
    BiblePaneState state,
    int column,
    dynamic translationId,
  ) {
    final theme = Theme.of(context);
    final paneTheme = Theme.of(context).extension<BiblePaneGeneralTheme>()!;
    final proseTheme =
        context.select((CustomizerCubit c) => c.state.proseTheme);

    final baseStyle = TextStyle(
      height: 1.5,
      fontFamily: paneTheme.textFont,
      fontWeight: paneTheme.textFontWeight,
    );
    final highlight = theme.colorScheme.primaryContainer;

    final unionRefs = state.unionRefs.toList();
    final anchors = _anchorsFor(column);
    anchors.removeWhere((ref, _) => !unionRefs.contains(ref));

    final blocks = <Widget>[];
    var currentSpans = <InlineSpan>[];

    void flushParagraph() {
      if (currentSpans.isEmpty) return;
      blocks.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: SelectableText.rich(
            TextSpan(style: baseStyle, children: [
              // paragraph indent
              WidgetSpan(
                  child: SizedBox(width: (TextStyle().fontSize ?? 16) * 2)),
              ...List.of(currentSpans)
            ]),
          ),
        ),
      );
      currentSpans = [];
    }

    for (final ref in unionRefs) {
      final verse =
          state.content.getParallelDataByBibleId(translationId)?.verses?[ref];
      if (verse == null) continue;

      final isHighlighted = state.reference?.contains(ref) ?? false;
      final verseBaseStyle = isHighlighted
          ? baseStyle.copyWith(backgroundColor: highlight)
          : baseStyle;
      final key = anchors.putIfAbsent(ref, () => GlobalKey());

      var isFirstSegmentOfVerse = true;

      for (final segment in verse.segments) {
        if (segment.heading != null) {
          flushParagraph();
          blocks.add(
            Padding(
              padding: const EdgeInsets.only(top: 22, bottom: 10),
              child: Text(
                segment.heading!,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          );
        }

        if (segment.isParagraphStart) {
          flushParagraph();
        }

        if (isFirstSegmentOfVerse) {
          // Zero-size anchor for Scrollable.ensureVisible().
          currentSpans.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: SizedBox(key: key, width: 0, height: 0),
            ),
          );

          currentSpans.add(
            TextSpan(
              text: '${ref.verseStart} ',
              style: VerseRefLabel.style(context, isHighlighted: isHighlighted)
                  .copyWith(fontSize: 12),
              recognizer: widget.onVerseTap != null
                  ? (TapGestureRecognizer()
                    ..onTap = () =>
                        widget.onVerseTap!(ref.copyWith(verseEnd: () => null)))
                  : null,
            ),
          );

          isFirstSegmentOfVerse = false;
        }

        currentSpans.addAll(
          VerseSpanBuilder.build(
            spans: segment.spans,
            context: context,
            baseStyle: verseBaseStyle,
            colorAlpha: proseTheme.emphasizeSelectedVerses && !isHighlighted
                ? (proseTheme.unselectedOpacityLevel * 255).toInt()
                : null,
            onWordTap: (span) => _onStrongsWordTap(context, span),
            onVerseTap: widget.onVerseTap == null
                ? null
                : () => widget.onVerseTap!(ref.copyWith(verseEnd: () => null)),
          ),
        );
      }
    }

    flushParagraph();

    return SingleChildScrollView(
      controller: _controllerFor(column),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // This empty text if for creating an empty space that grows
          // togheter with text size
          Container(
            padding: const EdgeInsets.only(top: 12, bottom: 32),
            child: const Text(''),
          ),
          ...blocks,
        ],
      ),
    );
  }
}
