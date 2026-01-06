import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_smyrna_bible_v2/features/b_searchbar/presenter/bloc/b_searchbar_bloc.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_selector/presenter/widget/bible_selector.dart';

import '../../../../../core/presentation/widgets/adjustable_text_size.dart';
import '../../../../../injection_container.dart';
import '../bloc/bible_pane_bloc.dart';

class BiblePane extends StatelessWidget {
  final int uniqueId;
  final BiblePaneBloc bloc;

  BiblePane({
    required this.uniqueId,
    required this.bloc,
    super.key,
  });

  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<BiblePaneBloc, BiblePaneState>(
        builder: (context, state) {
          print(state.status.toString());
          switch (state.status) {
            case BiblePaneStatus.initial:
              if (state.bibleId == null) {
                return BibleSelector(onConfirm: (bibleId) {
                  bloc.add(BiblePaneOpen(bibleId));
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
              print('reference here ${state.reference}');
              print(state.verses.length);

              return state.verses.isNotEmpty
                  ? AdjustableTextSize(
                      scrollController: controller,
                      initialiSize: 10,
                      child: ListView.builder(
                          controller: controller,
                          itemCount: state.verses.length,
                          itemBuilder: (_, i) {
                            return Text(state.verses[i].textContent);
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

/*
class VerseList extends StatefulWidget {
  final PageContent content;

  const VerseList({
    super.key,
    required this.content,
  });

  @override
  State<VerseList> createState() => _VerseListState();
}

class _VerseListState extends State<VerseList> {
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
    return AdjustableTextSize(
      scrollController: scrollController,
      initialiSize: 18,
      child: Builder(
        builder: (context) {
          final list = styleFrontend(context);

          return SelectionArea(
            child: ListView.builder(
              controller: scrollController,
              itemCount: list.length,
              itemBuilder: (_, index) {
                return list[index];
              },
            ),
          );
        },
      ),
    );
  }

  TextStyle styleVerse(Snippet w) {
    // given the word properties
    // style accordinly
    return TextStyle(
      fontWeight: w.bold
          ? FontWeight.bold
          : w.italics
              ? FontWeight.w500
              : FontWeight.normal,
      fontStyle: w.italics ? FontStyle.italic : FontStyle.normal,
      color: w.wordOfJesus
          ? w.italics
              ? Colors.red.withOpacity(0.4)
              : Colors.red
          : w.italics
              ? Colors.black.withOpacity(0.4)
              : null,
    );
  }

  List<Widget> styleFrontend(context) {
    final List<Widget> colVerses = [];
    final String booknameAbbreviation = widget.content.booknameAbbreviation!;
    final String booknameFull = widget.content.booknameFull!;
    final int chapterNumber = widget.content.chapterNumber!;
    final bool isHeterogeneous = widget.content.isHeterogeneous;
    //
    // If it is the first chapter of the book,
    // then add at the start the full name of the book
    //
    if (chapterNumber == 1 && !isHeterogeneous) {
      colVerses.add(
        Align(
          alignment: Alignment.center,
          child: Text(
            booknameFull,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: DefaultTextStyle.of(context).style.fontSize! * 1.2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      colVerses.add(const Gap(25));
    }
    //
    // Add each verse
    //
    widget.content.content.toList().forEach((paragraph) {
      paragraph.verses.toList().forEach((verse) {
        late Text verseWidget;
        final List<InlineSpan> content = [];
        //
        // Add numbering reference before a verse
        //
        content.add(
          TextSpan(
            text: '$booknameAbbreviation $chapterNumber:${verse.number}  ',
            style: TextStyle(
              color: Colors.blue[700],
              fontWeight: FontWeight.w600,
            ),
          ),
        );
        //
        // Add verse words with its own styling
        //
        for (var w in verse.words) {
          content.add(TextSpan(text: '${w.text} ', style: styleVerse(w)));
        }
        verseWidget = Text.rich(TextSpan(children: content));
        colVerses.add(verseWidget);
      });
      //
      // add spacing between each paragrah
      //
      colVerses.add(const Gap(50));
    });
    return colVerses;
  }
}
*/
