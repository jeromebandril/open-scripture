import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/domain/entities/bible_ref.dart';
import '../../../../../shared/domain/entities/verse.dart';
import '../../../../customizer/presentation/models/bible_pane_general_theme.dart';
import '../../../../customizer/presentation/models/bible_view_list_theme.dart';
import '../../../multi_pane_manager/presentation/state/multi_pane_manager_cubit.dart';
import '../rendering/verse_richtext_builder.dart';
import '../state/bible_pane_bloc.dart';

/// A "continuous" reading view: verses flow together as ordinary prose,
/// broken only where the data says a paragraph or heading starts, instead
/// of being rendered as one discrete row per verse (as `BibleViewList` does).
///
/// Drop this in wherever `BibleViewList` is used today — it reads from the
/// same `BiblePaneBloc` / `MultiPaneManagerCubit` and supports the same
/// multi-pane parallel-translation layout.
///
/// Two things are left for you to wire up, since they depend on APIs not
/// shown to me (rather than guessing and risking a broken build):
///
/// - [verseLabelBuilder]: turn a [BibleRef] into the small verse-number
///   label, e.g. `(ref) => ref.verseStart.toString()` — adjust the field
///   name to whatever your `BibleRef` actually exposes for the verse number.
/// - [onVerseTap]: called when the reader taps a verse's text. Wire this to
///   whatever currently updates `state.reference` when a verse is tapped in
///   `VerseWidget`, so selection behaves identically in both views.
class BibleViewContinuous extends StatefulWidget {
  const BibleViewContinuous({
    super.key,
    required this.uniqueId,
    required this.verseLabelBuilder,
    this.onVerseTap,
    this.onWordTap,
    this.highlightColor,
    this.showVerseNumbers = true,
  });

  final int uniqueId;

  /// Builds the small leading verse-number label shown before each verse.
  final String Function(BibleRef ref) verseLabelBuilder;

  /// Fired when the reader taps anywhere in a verse's text. Strong's-tagged
  /// words keep triggering [onWordTap] instead.
  final void Function(BibleRef ref)? onVerseTap;

  /// Passed straight through to [VerseSpanBuilder.build], useful for Strong's-word
  /// tapping (e.g. opening a definition).
  final void Function(VerseSpan span)? onWordTap;

  /// Background painted behind the selected verse's text. Defaults to
  /// `colorScheme.primaryContainer`.
  final Color? highlightColor;

  /// Whether to show the small verse-number marker before each verse.
  final bool showVerseNumbers;

  @override
  State<BibleViewContinuous> createState() => _BibleViewContinuousState();
}

class _BibleViewContinuousState extends State<BibleViewContinuous> {
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
          alignment: 0.2,
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
      final ref = bloc.state.reference;
      if (ref != null) {
        _scheduleScrollToRef(ref.copyWith(verseEnd: () => null));
      }
    });
  }

  @override
  void dispose() {
    for (final controller in _scrollControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
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

        return Padding(
          padding: EdgeInsets.only(
            left: thisPaneIndex == 0 ? screen.width * paneTheme.xPadding : 0,
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
                  child: _buildColumn(context, state, col, parallelOrder[col]),
                ),
            ],
          ),
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

    final headingStyle = TextStyle(color: Colors.blue);
    final verseStyle = TextStyle(
      fontSize: 16,
      height: 1.5,
      fontWeight: paneTheme.textFontWeight,
      fontFamily: paneTheme.textFont,
    );
    final highlight = widget.highlightColor ??
        theme.colorScheme.primaryContainer.withOpacity(0.55);

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
          child: Text.rich(
            TextSpan(style: verseStyle, children: List.of(currentSpans)),
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
          ? verseStyle.merge(TextStyle(backgroundColor: highlight))
          : verseStyle
              .merge(TextStyle(color: paneTheme.textColor.withAlpha(100)));
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
                style: headingStyle,
              ),
            ),
          );
        }

        if (segment.isParagraphStart) {
          flushParagraph();
        }

        if (isFirstSegmentOfVerse) {
          // Anchor
          currentSpans.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: SizedBox(key: key, width: 0, height: 0),
            ),
          );

          if (widget.showVerseNumbers) {
            currentSpans.add(
              TextSpan(
                text: '${widget.verseLabelBuilder(ref)} ',
                style: verseBaseStyle.copyWith(
                  fontSize: 11,
                  fontWeight: paneTheme.refFontWeight,
                  color: paneTheme.refColor,
                ),
                recognizer: widget.onVerseTap != null
                    ? (TapGestureRecognizer()
                      ..onTap = () => widget.onVerseTap!(ref))
                    : null,
              ),
            );
          }

          isFirstSegmentOfVerse = false;
        }

        currentSpans.addAll(
          VerseSpanBuilder.build(
            spans: segment.spans,
            context: context,
            baseStyle: verseBaseStyle,
            onWordTap: widget.onWordTap,
            // onVerseTap: widget.onVerseTap == null
            //     ? null
            //     : () => widget.onVerseTap!(ref),
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
        children: blocks,
      ),
    );
  }
}
