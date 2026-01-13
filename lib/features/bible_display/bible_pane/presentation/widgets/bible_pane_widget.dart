import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_smyrna_bible_v2/core/domain/entities/verse_segment.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_pane/presentation/cubit/selected_word_cubit.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_pane/presentation/widgets/pane_info.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_selector/presenter/widget/bible_selector.dart';

import '../../../../../core/presentation/widgets/adjustable_text_size.dart';
import '../bloc/bible_pane_bloc.dart';
import 'verse_widget.dart';

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
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: widget.bloc),
        BlocProvider(
            create: (_) => SelectedWordCubit()), // for one pane only for now
      ],
      child: BlocBuilder<BiblePaneBloc, BiblePaneState>(
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
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LinearProgressIndicator(),
                  Text('Opening the bible...')
                ],
              );
            //
            // ERROR SCREEN
            //
            case BiblePaneStatus.error:
              return Text(state.errorMessage ?? 'An error occurred');
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
                            scrollController: _scrollController,
                            initialiSize: 24,
                            child: ListView.builder(
                                controller: _scrollController,
                                itemCount: verseNumbers.length + 1,
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
                                }),
                          ),
                  ),
                  //
                  // PANE STATUS INFO
                  //
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: PaneInfo(),
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
    );
  }
}
