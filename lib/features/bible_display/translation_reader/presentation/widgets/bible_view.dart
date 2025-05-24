import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:the_smyrna_bible_v2/features/b_searchbar/presenter/bloc/b_searchbar_bloc.dart';

import '../../../../../core/presentation/widgets/adjustable_text_size.dart';
import '../../../../../injection_container.dart';
import '../bloc/reader_bloc.dart';

class BibleView extends StatelessWidget {
  final int? uniqueId;
  final List<String> items;
  const BibleView({this.uniqueId, required this.items, super.key});

  @override
  Widget build(BuildContext context) {
    print(key);
    return GestureDetector(
      onTap: () => print("tap"),
      child: BlocProvider(
        create: (_) =>
            sl<ReaderBloc>()..add(const ReaderLoadTranslation('eng-kjv')),
        child: BlocBuilder<ReaderBloc, ReaderState>(
          builder: (context, state) {
            // error case
            if (state.status == ReaderStatus.reading) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LinearProgressIndicator(),
                  Text('Opening the bible...')
                ],
              );
            }
            if (state.status == ReaderStatus.error) {
              return const Text('ERROR');
            }
            // success case
            return BlocListener<BSearchbarBloc, BSearchbarState>(
              listener: (context, state) {
                if (state.referenceResult == null) return;
                BlocProvider.of<ReaderBloc>(context).add(
                  ReaderDisplay(state.referenceResult),
                );
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 24, 0, 0),
                child: state.page != null
                    ? VerseList(
                        content: state.page!,
                      )
                    : const SizedBox(),
              ),
            );
          },
        ),
      ),
    );
  }

  // for testing
  void read(context) {
    BlocProvider.of<ReaderBloc>(context).add(
      const ReaderLoadTranslation('eng-kjv'),
    );
  }
}

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
