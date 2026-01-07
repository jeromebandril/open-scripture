import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:the_smyrna_bible_v2/core/domain/entities/verse_segment.dart';
import 'package:the_smyrna_bible_v2/core/domain/entities/verse_span.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_pane/presentation/rendering/verse_richtext_builder.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_selector/presenter/widget/bible_selector.dart';

import '../../../../../core/presentation/widgets/adjustable_text_size.dart';
import '../bloc/bible_pane_bloc.dart';

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
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<BiblePaneBloc, BiblePaneState>(
        builder: (context, state) {
          switch (state.status) {
            case BiblePaneStatus.initial:
              if (state.bibleId == null) {
                return BibleSelector(onConfirm: (bibleId) {
                  widget.bloc.add(BiblePaneOpen(bibleId));
                });
              }
              return SizedBox();
            case BiblePaneStatus.loading:
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LinearProgressIndicator(),
                  Text('Opening the bible...')
                ],
              );
            case BiblePaneStatus.error:
              return Text(state.errorMessage ?? 'An error occurred');

            case BiblePaneStatus.ready:
              return state.segments.isNotEmpty
                  ? AdjustableTextSize(
                      scrollController: scrollController,
                      initialiSize: 10,
                      child: ListView.builder(
                          controller: scrollController,
                          itemCount: state.segments.length,
                          itemBuilder: (_, i) {
                            final segments = state.segments
                                .where((v) => v.ref.verseStart == i + 1)
                                .toList();
                            final spans =
                                segments.expand((s) => s.spans).toList();
                            return VerseWidget(
                              verseNumber: i + 1,
                              segments: segments,
                              spans: spans,
                            );
                          }),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(12, 24, 0, 0),
                      child: Text("Pronto al tuo servizio padrone"),
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

class VerseWidget extends StatelessWidget {
  final int verseNumber;
  final List<VerseSegment> segments;
  final List<VerseSpan>? spans;

  const VerseWidget({
    required this.verseNumber,
    required this.segments,
    this.spans,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final String content = segments.map((e) => e.textContent).join();

    return Row(
      children: [
        SizedBox(
          child: Text(textAlign: TextAlign.end, verseNumber.toString()),
        ),
        Gap(24),
        Flexible(
            child: spans == null
                ? Text(content)
                : SelectableText.rich(
                    VerseSpanBuilder.build(
                      text: content,
                      spans: spans!,
                      onWordTap: (VerseSpan span, String slice) {},
                      // onSpanTap: (span, txt) {
                      //   if (span.type == 'w') {
                      //     // span.payload might be "H0430" etc.
                      //     // open dictionary popup, etc.
                      //   }
                      // },
                    ),
                  ))
      ],
    );
  }
}
