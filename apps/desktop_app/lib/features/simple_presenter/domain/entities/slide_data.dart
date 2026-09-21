class SlideData {
  final String? id;
  final String title;
  final String? subtitle;

  const SlideData({
    required this.title,
    this.subtitle,
    this.id,
  });

  SlideData copyWith({
    String? title,
    String? subtitle,
  }) {
    return SlideData(
      id: id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
    );
  }
}
