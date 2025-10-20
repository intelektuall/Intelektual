class News {
  final String id;
  final String headline;
  final String content;
  final DateTime date;
  final String imageUrl;
  final String category;

  News({
    required this.id,
    required this.headline,
    required this.content,
    required this.date,
    required this.imageUrl,
    required this.category,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'] ?? '',
      headline: json['headline'] ?? '',
      content: json['content'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? 'latest',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'headline': headline,
    'content': content,
    'date': date.toIso8601String(),
    'imageUrl': imageUrl,
    'category': category,
  };
}
