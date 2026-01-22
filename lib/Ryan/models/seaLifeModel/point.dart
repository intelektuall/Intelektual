import '../../services/localization_helper.dart';

class Point {
  /// 🔥 Map multilingual
  final Map<String, dynamic> title;

  /// 🔥 description optional & multilingual
  final Map<String, dynamic>? description;

  Point({
    required this.title,
    this.description,
  });

  factory Point.fromJson(Map<String, dynamic> json) {
    final titleMap =
        Map<String, dynamic>.from(json['title'] ?? {});

    final rawDescription = json['description'];
    final Map<String, dynamic>? descriptionMap =
        rawDescription is Map<String, dynamic> && rawDescription.isNotEmpty
            ? Map<String, dynamic>.from(rawDescription)
            : null;

    return Point(
      title: titleMap,
      description: descriptionMap,
    );
  }

  /// 🔥 INI YANG DIPAKAI UI
  String getTitle(String locale) {
    return localizedValue(title, locale);
  }

  String? getDescription(String locale) {
    if (description == null) return null;
    final value = localizedValue(description, locale);
    return value.isNotEmpty ? value : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      if (description != null) 'description': description,
    };
  }

  Point copyWith({
    Map<String, dynamic>? title,
    Map<String, dynamic>? description,
  }) {
    return Point(
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}
