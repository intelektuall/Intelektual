import '../../services/localization_helper.dart';
import 'section.dart';

class Ocean {
  final String id;

  /// 🔥 MAP multilingual
  final Map<String, dynamic> name;

  final String imagePath;
  final List<Section> sections;

  Ocean({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.sections,
  });

  factory Ocean.fromJson(Map<String, dynamic> json) {
    final rawSections = json['sections'];
    List<Section> parsedSections = [];

    if (rawSections is List) {
      parsedSections = rawSections
          .whereType<Map<String, dynamic>>()
          .map((item) => Section.fromJson(item))
          .toList();
    }

    return Ocean(
      id: json['id']?.toString() ?? '',

      /// ✅ parsing MAP multilingual
      name: Map<String, dynamic>.from(json['name'] ?? {}),

      imagePath: json['imagePath'] ?? '',
      sections: parsedSections,
    );
  }

  /// 🔥 INI SATU-SATUNYA YANG DIPAKAI UI
  String getName(String locale) {
    return localizedValue(name, locale);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'sections': sections.map((s) => s.toJson()).toList(),
    };
  }

  Ocean copyWith({
    String? id,
    Map<String, dynamic>? name,
    String? imagePath,
    List<Section>? sections,
  }) {
    return Ocean(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      sections: sections ?? this.sections,
    );
  }
}
