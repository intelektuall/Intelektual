import 'point.dart';

class Section {
  final String title;
  final String? text;
  final List<Point> points;

  Section({
    required this.title,
    required this.text,
    required this.points,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    final rawText = json['text'] as String?;
    final normalizedText = (rawText != null && rawText.trim().isNotEmpty) ? rawText.trim() : null;
    return Section(
      title: json['title'] ?? '',
      text: normalizedText,
      points: (json['points'] as List<dynamic>?)
              ?.map((item) => Point.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'text': text,
      'points': points.map((p) => p.toJson()).toList(),
    };
  }

  Section copyWith({
    String? title,
    String? text,
    List<Point>? points,
  }) {
    return Section(
      title: title ?? this.title,
      text: text ?? this.text,
      points: points ?? this.points,
    );
  }
}
