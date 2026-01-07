import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: widget.bloc),
        BlocProvider(
            create: (_) => SelectedWordCubit()), // for one pane only for now
      ],
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
              return Container(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Stack(
                  children: [
                    state.segments.isNotEmpty
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
                          ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: PaneInfo(),
                    ),
                  ],
                ),
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
