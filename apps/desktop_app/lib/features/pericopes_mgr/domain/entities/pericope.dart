class Pericope {
  final String title;
  final int bookId;
  final int startChapter;
  final int startVerse;
  final int endChapter;
  final int endVerse;

  const Pericope({
    required this.title,
    required this.bookId,
    required this.startChapter,
    required this.startVerse,
    required this.endChapter,
    required this.endVerse,
  });
}
