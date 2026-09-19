class Pericope {
  final int? setId;
  final int bookId;
  final int chapter;
  final int startVerse;
  final int endVerse;
  final String title;

  const Pericope({
    this.setId,
    required this.bookId,
    required this.chapter,
    required this.startVerse,
    required this.endVerse,
    required this.title,
  });
}
