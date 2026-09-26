class SlideData {
  final String? id;
  final String title;
  final String? subtitle;
  final String? topLeft;
  final String? topRight;
  final String? bottomLeft;
  final String? bottomRight;

  const SlideData({
    this.id,
    required this.title,
    this.subtitle,
    this.topLeft,
    this.topRight,
    this.bottomLeft,
    this.bottomRight,
    Object? data,
  });

  SlideData copyWith({
    String? title,
    String? Function()? subtitle,
  }) {
    return SlideData(
      id: id,
      title: title ?? this.title,
      subtitle: subtitle != null ? subtitle() : this.subtitle,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "subtitle": subtitle,
    };
  }

  static SlideData fromJson(Map<String, dynamic> data) {
    return SlideData(
      id: data['id'],
      title: data['title'],
      subtitle: data['subtitle'],
    );
  }
}
