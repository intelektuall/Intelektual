class Point {
  final String title;
  final String? description;

  Point({
    required this.title,
    this.description,
  });

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      if (description != null) 'description': description,
    };
  }

  Point copyWith({
    String? title,
    String? description,
  }) {
    return Point(
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}
