import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:the_smyrna_bible_v2/core/domain/entities/verse_segment.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_pane/presentation/cubit/selected_word_cubit.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_pane/presentation/widgets/parts/pane_info.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_selector/presenter/widget/bible_selector.dart';
import 'package:the_smyrna_bible_v2/features/customizer/domain/entities/bible_pane_theme.dart';
import 'package:the_smyrna_bible_v2/features/customizer/presentation/cubit/customizer_cubit.dart';

import '../../../../../core/presentation/widgets/adjustable_text_size.dart';
import '../bloc/bible_pane_bloc.dart';
import 'parts/verse_divider.dart';
import 'parts/verse_widget.dart';

class BiblePane extends StatefulWidget {
  final int uniqueId;
  final BiblePaneBloc bloc;

  const BiblePane({
    required this.uniqueId,
    required this.bloc,
    super.key,
  });

  @override
  State<BiblePane> createState() => _BiblePaneState();
}

class _BiblePaneState extends State<BiblePane> {
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
    bool isCustom = context.select(
      (CustomizerCubit c) => c.state.pane.enableCustomTheme,
    );
    final paneTheme = Theme.of(context).extension<BiblePaneTheme>()!;

    return DefaultTextStyle(
      style: TextStyle(
        color: isCustom
            ? paneTheme.textColor
            : Theme.of(context).colorScheme.onSurface,
        fontFamily: isCustom ? paneTheme.fontFamily : null,
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: widget.bloc),
          BlocProvider(
              create: (_) => SelectedWordCubit()), // for one pane only for now
        ],
        child: BlocConsumer<BiblePaneBloc, BiblePaneState>(
          listenWhen: (prev, curr) =>
              prev.reference != curr.reference && curr.reference != null,
          listener: (context, state) =>
              _scrollUntilVisible(state.reference!.verseStart! - 1),
          builder: (context, state) {
            switch (state.status) {
              //
              // INITIAL
              //
              case BiblePaneStatus.initial:
                if (state.bibleId == null) {
                  return BibleSelector(onConfirm: (bibleId) {
                    widget.bloc.add(BiblePaneOpen(bibleId));
                  });
                }
                return SizedBox();
              //
              // LOADING SCREEN
              //
              case BiblePaneStatus.loading:
                return Center(child: CircularProgressIndicator());
              //
              // ERROR SCREEN
              //
              case BiblePaneStatus.error:
                return Center(child: Text(state.errorMessage ?? 'Error'));
              //
              // READY SCREEN
              //
              case BiblePaneStatus.ready:
                // group segments by verse number
                final segmentsByVerse = <int, List<VerseSegment>>{};

                for (final s in state.segments) {
                  final key = s.ref.verseStart; // assuming int
                  (segmentsByVerse[key!] ??= <VerseSegment>[]).add(s);
                }

                final verseNumbers = segmentsByVerse.keys.toList()..sort();

                return Stack(
                  children: [
                    //
                    // MAIN VIEW
                    //
                    Positioned.fill(
                      child: state.segments.isEmpty
                          ? Center(
                              child: Text(
                              "Ready :)",
                            ))
                          : AdjustableTextSize(
                              initialiSize: 14,
                              child: ScrollablePositionedList.separated(
                                itemScrollController: _itemScrollController,
                                itemPositionsListener: _itemPositionsListener,
                                itemCount: verseNumbers.length + 1,
                                padding: EdgeInsets.only(top: 16),
                                separatorBuilder: (ctx, _) {
                                  return VerseDivider();
                                },
                                itemBuilder: (_, i) {
                                  // Fixed empty space at the bottom
                                  if (i == verseNumbers.length) {
                                    return const SizedBox(height: 200);
                                  }

                                  final vn = verseNumbers[i];
                                  final segments = segmentsByVerse[vn]!;
                                  final spans =
                                      segments.expand((s) => s.spans).toList();
                                  final vStart = state.reference?.verseStart;
                                  final vEnd = state.reference?.verseEnd;

                                  return VerseWidget(
                                      verseNumber: vn,
                                      segments: segments,
                                      spans: spans,
                                      isHighlighted:
                                          (vEnd == null && vn == vStart) ||
                                              (vEnd != null &&
                                                  vStart != null &&
                                                  vn >= vStart &&
                                                  vn <= vEnd));
                                },
                              ),
                            ),
                    ),
                    //
                    // PANE STATUS INFO
                    //
                    DefaultTextStyle(
                      style: TextStyle(),
                      child: Positioned(
                        bottom: 0,
                        right: 0,
                        child: PaneInfo(),
                      ),
                    ),
                  ],
                );

              // success case
              // return BlocListener<BSearchbarBloc, BSearchbarState>(
              //   listener: (context, state) {
              //     if (state.referenceResult == null) return;
              //     BlocProvider.of<ReaderBloc>(context).add(
              //       BiblePaneDisplayVerses(state.referenceResult!),
              //     );
              //   },
            }
          },
        ),
      ),
    );
  }
}
