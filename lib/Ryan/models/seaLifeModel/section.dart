import '../../services/localization_helper.dart';
import 'point.dart';

class Section {
  /// 🔥 Map multilingual
  final Map<String, dynamic> title;

  /// 🔥 text bisa null atau map multilingual
  final Map<String, dynamic>? text;

  final List<Point> points;

  Section({
    required this.title,
    this.text,
    required this.points,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    /// title WAJIB map
    final titleMap =
        Map<String, dynamic>.from(json['title'] ?? {});

    /// text OPTIONAL & multilingual
    final rawText = json['text'];
    final Map<String, dynamic>? textMap =
        rawText is Map<String, dynamic> && rawText.isNotEmpty
            ? Map<String, dynamic>.from(rawText)
            : null;

    return Section(
      title: titleMap,
      text: textMap,
      points: (json['points'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map((item) => Point.fromJson(item))
              .toList() ??
          [],
    );
  }

  /// 🔥 INI YANG DIPAKAI UI
  String getTitle(String locale) {
    return localizedValue(title, locale);
  }

  String? getText(String locale) {
    if (text == null) return null;
    final value = localizedValue(text, locale);
    return value.isNotEmpty ? value : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'text': text,
      'points': points.map((p) => p.toJson()).toList(),
    };
  }

  Section copyWith({
    Map<String, dynamic>? title,
    Map<String, dynamic>? text,
    List<Point>? points,
  }) {
    return Section(
      title: title ?? this.title,
      text: text ?? this.text,
      points: points ?? this.points,
    );
  }
}
