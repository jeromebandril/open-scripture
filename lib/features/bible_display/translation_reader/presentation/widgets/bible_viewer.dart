import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_smyrna_bible_v2/core/widgets/adjustable_text_size.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/presentation/bloc/reader_bloc.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/translation_reader/presentation/widgets/bible_finder.dart';

import '../../../scripture_finder/domain/entity/bible_reference.dart';
import '../../../../translations_installer_manager/domain/entities/translation.dart';

class BibleViewer extends StatelessWidget {
  const BibleViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: BlocBuilder<ReaderBloc, ReaderState>(
            builder: (context, state) {
              if (state.status == ReaderStatus.reading) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LinearProgressIndicator(),
                    Text('Initializing...')
                  ],
                );
              }
              if (state.status == ReaderStatus.error) {
                return const Text('ERROR');
              }
              return Builder(builder: (context) {
                return Column(
                  children: [
                    const SizedBox(
                      height: 50,
                      child: BibleFinder(),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 24, 0, 0),
                        child: ChapterView(
                          translations: state.viewer.translations,
                          referenceToDisplay: state.references,
                        ),
                      ),
                    ),
                  ],
                );
              });
            },
          ),
        ),
      ],
    );
  }

  // for testing
  void read(context) {
    BlocProvider.of<ReaderBloc>(context).add(
      const ReaderReadTranslation('eng-kjv'),
    );
  }
}

class ChapterView extends StatefulWidget {
  final List<Translation> translations;
  final List<BibleReference> referenceToDisplay;

  const ChapterView({
    super.key,
    required this.translations,
    required this.referenceToDisplay,
  });

  @override
  State<ChapterView> createState() => _ChapterViewState();
}

class _ChapterViewState extends State<ChapterView> {
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

  List<Widget> styleFrontend(context) {
    final List<Widget> verses = [];
    // for each reference create Row
    for (var ref in widget.referenceToDisplay) {
      late Row row;
      final List<Expanded> translationCol = [];
      // for each translation create a column
      for (var translation in widget.translations) {
        late Column col;
        final List<Widget> colVerses = [];

        final book = translation.bookNames.values.where((bookData) {
          return bookData.abbr.toUpperCase().startsWith(ref.book) &&
              bookData.short.toUpperCase().contains(ref.book);
          // bookData.long.toUpperCase().startsWith(ref.book) &&
        }).firstOrNull;

        // if a translation doesn't resolve the reference
        // it will be empty
        if (book != null) {
          if (ref.chapter > book.chapters.length || ref.chapter < 0) {
            return List.empty();
          }
          final chapter = book.chapters[ref.chapter];
          final paragraphs = chapter.paragraphs;

          if (chapter.number == 1) {
            colVerses.add(
              Align(
                alignment: Alignment.center,
                child: Text(
                  book.long,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize:
                        DefaultTextStyle.of(context).style.fontSize! * 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
            colVerses.add(const SizedBox(height: 25));
          }

          // style the text display
          for (var par in paragraphs) {
            for (var verse in par.verses) {
              late Text verseWidget;
              final List<InlineSpan> content = [];
              // add numbering
              content.add(
                TextSpan(
                  text: '${book.abbr} ${chapter.number}:${verse.number}  ',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
              // add verse words
              for (var w in verse.words) {
                content.add(
                  TextSpan(
                    text: '${w.text} ',
                    style: TextStyle(
                      fontWeight: w.bold
                          ? FontWeight.bold
                          : w.italics
                              ? FontWeight.w500
                              : FontWeight.normal,
                      fontStyle:
                          w.italics ? FontStyle.italic : FontStyle.normal,
                      color: w.wordOfJesus
                          ? w.italics
                              ? Colors.red.withOpacity(0.4)
                              : Colors.red
                          : w.italics
                              ? Colors.black.withOpacity(0.4)
                              : null,
                    ),
                  ),
                );
              }
              verseWidget = Text.rich(
                TextSpan(children: content),
              );
              colVerses.add(verseWidget);
            }
            colVerses.add(const Text(
              '',
            ));
          }
        }
        col = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: colVerses,
        );
        translationCol.add(Expanded(child: col));
      }

      row = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: translationCol,
      );
      verses.add(row);
    }
    return verses;
  }
}
