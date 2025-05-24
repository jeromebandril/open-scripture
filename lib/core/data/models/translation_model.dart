import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

class TranslationModel extends Translation {
  const TranslationModel({
    required String name,
    required String abbreviation,
    required String language,
    required Map<String, Book> bookNames,
  }) : super(
          name: name,
          abbreviation: abbreviation,
          language: language,
          bookNames: bookNames,
        );

  ///
  /// I hope you don't have to look at this ever again
  ///
  factory TranslationModel.fromUSFX(String metadataXml, String sourceXml) {
    XmlDocument metadata = XmlDocument.parse(metadataXml);
    XmlDocument source = XmlDocument.parse(sourceXml);

    Map<String, Book> bookNames = {};

    ///
    /// This function doesn't return anything, instead it requires
    /// a List<Word> where to add the results.
    /// It resolves the heriarchy of an element when it
    /// has still descendants (in this case
    /// with the porpouse of applying different styles i.e.
    /// a \<w> can also be enclose with \<wj>, which is word of jesus
    ///  or \<add>, which is italics)
    /// until it meets the last one, which text is added to the list.
    ///
    void resolve(
      List<Snippet> snippets,
      XmlNode xe, {
      bool italics = false,
      bool wordOfJesus = false,
    }) {
      bool i = italics;
      bool wj = wordOfJesus;

      if (xe is XmlText) {
        snippets.add(
          Snippet(text: xe.value.trim(), italics: i, wordOfJesus: wj),
        );
        return;
      }

      xe as XmlElement;

      if (xe.descendantElements.isEmpty) {
        snippets.add(
          Snippet(
            text: xe.innerText.trim(),
            italics: xe.name.local == 'add' || i,
            wordOfJesus: xe.name.local == "wj" || wj,
            bold: xe.innerText.contains('Lord'),
            scn: xe.getAttribute('s'),
          ),
        );
        return;
      } else {
        wj = xe.name.local == 'wj';
        italics = xe.name.local == 'add';

        List<XmlNode> list = xe.children
            .where(
              (e) => (e is XmlElement ||
                  (e is XmlText && e.value.trim().isNotEmpty)),
            )
            .toList();

        for (var d in list) {
          resolve(snippets, d, italics: i, wordOfJesus: wj);
        }
      }
    }

    final modifiedSource = source
        .findAllElements('book')
        .where((element) => element.getAttribute('id') != 'FRT')
        .toList();

    // Go trough all books exept for the Praface (for now)
    for (final book in modifiedSource) {
      String? bookId;
      String? abbr;
      String? short;
      String? long;
      List<Chapter> bookChapters = [];
      List<Paragraph> chapterParagraphs = [];
      bool chapterStart = false;
      int chapterId = 0;
      Paragraph? par;

      bookId = book.getAttribute('id')!;

      for (var element in book.childElements) {
        switch (element.name.local) {
          // Gets the book metadata, such as book titles
          case 'toc':
            if (element.getAttribute('level') == '1') long = element.innerText;
            if (element.getAttribute('level') == '2') short = element.innerText;
            if (element.getAttribute('level') == '3') abbr = element.innerText;
            break;
          // Start of a chapter
          case 'c':
            chapterStart = true;
            chapterId = int.parse(element.getAttribute("id")!);
            if (chapterParagraphs.isNotEmpty) {
              bookChapters.add(
                Chapter(
                  number: chapterId - 1,
                  paragraphs: chapterParagraphs,
                ),
              );
              chapterParagraphs = [];
            }
            break;
          // Start of a paragraph (in a well formatted
          // usfx file this means that a start of chapter
          // has been already encountered).
          // This fills the paragraph with its proper content,
          // at the end it will be added to the Chapter
          //
          // attention: in psalms kjv there's there's no <p> elements
          // instead there's a new element <q> which stands for "quote"
          // that wraps each verse
          case 'q':
          case 'p':
            List<Verse> paragraphVerses = [];

            if (element.getAttribute('sfm') == null) {
              // variables //
              bool verseStart = false;
              List<Snippet> verseWords = [];
              int verseId = 0;
              List<XmlNode> paragraphChildren = element.children
                  .where(
                    (e) => ((e is XmlElement && e.name.local != 'f') ||
                        (e is XmlText && e.value.trim().isNotEmpty)),
                  )
                  .toList();

              // get content //
              for (var pNode in paragraphChildren) {
                // if milestone "verse end" is encountered, then
                // add this new Verse to Paragraph
                if (pNode is XmlElement && pNode.name.local == 've') {
                  paragraphVerses.add(Verse(
                    number: verseId,
                    words: verseWords,
                  ));
                  verseStart = false;
                }
                // if a verse has started, then this node is part
                // of its content.
                if (verseStart) {
                  List<Snippet> temp = [];
                  resolve(temp, pNode);
                  verseWords.addAll(temp);
                }
                // if milestone "verse start" has been encountered,
                // then init a new Verse (next nodes will be surely its content)
                if (pNode is XmlElement && pNode.name.local == 'v') {
                  verseWords = [];
                  verseId = int.parse(pNode.getAttribute('id')!);
                  verseStart = true;
                }
              }
            }
            // end of analzying the paragraph
            par = Paragraph(title: '', verses: paragraphVerses);
            // when the line below happens it means it is the preface
            // chapter ??= const Chapter(number: 0, paragraphs: []);
            if (chapterStart) {
              chapterParagraphs.add(par);
            }
            break;
        }
      }
      // always end by adding the last analyzed chapter,
      // this is because Usfx doesn't have a closing
      // tag for Chapter, so the last element of this type
      // would never get stored without this
      if (chapterStart) {
        bookChapters.add(
          Chapter(
            number: chapterId,
            paragraphs: chapterParagraphs,
          ),
        );
      }

      bookNames[bookId] = Book(
        abbr: abbr?.trim() ?? 'unknown',
        short: short?.trim() ?? 'unnown',
        long: long?.trim() ?? 'unknown',
        chapters: bookChapters,
      );
    }

    return TranslationModel(
      name: metadata.xpath('DBLMetadata/identification/name').single.innerText,
      abbreviation: metadata
          .xpath('DBLMetadata/identification/abbreviation')
          .single
          .innerText,
      language: metadata.xpath('DBLMetadata/language/name').single.innerText,
      bookNames: bookNames,
    );
  }

  ///
  /// TODO: finish
  /// Temporary freezed because I'm not storing all the informations, which
  /// are needed to reconstruct the document (ex: sfm, the preface, the footers)
  ///
  XmlDocument toUSFX() {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('usfx', nest: () {
      builder.attribute(
        'xmlns:xsi',
        'http://www.w3.org/2001/XMLSchema-instance',
      );
      builder.attribute(
        'xsi:noNamespaceSchemaLocation',
        'https://eBible.org/usfx.xsd',
      );
      builder.element(
        'languageCode',
        nest: language,
      );
      for (var book in bookNames.entries) {
        builder.element('book', nest: () {
          builder.attribute('id', book.key);
          builder.element('id', nest: () {
            builder.attribute('id', book.key);
            builder.text(book.value.short);
          });
          builder.element('h', nest: book.key);
          builder.element('toc', nest: () {
            builder.attribute('level', '1');
            builder.text(book.value.long);
          });
          builder.element('toc', nest: () {
            builder.attribute('level', '2');
            builder.text(book.value.short);
          });
          builder.element('toc', nest: () {
            builder.attribute('level', '3');
            builder.text(book.value.abbr);
          });

          for (var chapter in book.value.chapters) {
            builder.element('c', attributes: {'id': '${chapter.number}'});
            for (var paragraph in chapter.paragraphs) {
              builder.element('p', nest: () {
                for (var verse in paragraph.verses) {
                  builder.element('v', attributes: {'id': '${verse.number}'});
                  for (var word in verse.words) {
                    word.italics;
                    word.wordOfJesus;
                    builder.element('add');
                    builder.element('w');
                    builder.element('wj');

                    // Rebuild styling heriarchy with <wj>, <add> and <w> and XmlText
                  }
                }
              });
            }
          }
        });
      }
    });

    return builder.buildDocument();
  }
}
